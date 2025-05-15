from flask import Flask, render_template, request, jsonify
import boto3
import os
import logging
from dotenv import load_dotenv

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

app = Flask(__name__)

# AWS Configuration - Using IRSA (no credentials needed)
AWS_REGION = os.getenv('AWS_REGION', 'us-east-1')  # Default to us-east-1 if not set
logger.info(f"Initializing AWS clients with region: {AWS_REGION}")

try:
    logger.info("Attempting to initialize SQS client...")
    sqs = boto3.client('sqs', region_name=AWS_REGION)
    logger.info("SQS client initialized successfully")
except Exception as e:
    logger.error(f"Error initializing AWS client: {e}")
    sqs = None

# Get queue URL from environment variable
SQS_QUEUE_URL = os.getenv('SQS_QUEUE_URL')
logger.info(f"SQS Queue URL: {SQS_QUEUE_URL}")

# Store the first three subscribers in memory
first_three_subscribers = []

def get_first_three_subscribers():
    """Retrieve the first three subscribers from the SQS queue"""
    global first_three_subscribers
    
    # If we already have three subscribers, return them
    if len(first_three_subscribers) >= 3:
        return first_three_subscribers
        
    try:
        # Receive up to 10 messages at a time
        response = sqs.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=10,
            AttributeNames=['All'],
            MessageAttributeNames=['All']
        )
        
        messages = response.get('Messages', [])
        for message in messages:
            # Parse the message body
            subscriber_data = eval(message['Body'])  # Convert string to dict
            
            # Check if this subscriber is already in our list
            if not any(sub['email'] == subscriber_data['email'] for sub in first_three_subscribers):
                first_three_subscribers.append(subscriber_data)
                
            if len(first_three_subscribers) >= 3:
                break
                
        return first_three_subscribers
    except Exception as e:
        logger.error(f"Error retrieving subscribers: {e}")
        return first_three_subscribers

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit_form():
    try:
        first_name = request.form['firstName']
        last_name = request.form['lastName']
        email = request.form['email']

        logger.info(f"Received form submission for: {first_name} {last_name}")

        # Check if we can add this subscriber to the first three
        is_first_three = False
        if len(first_three_subscribers) < 3:
            # Add to first three if we haven't reached three yet
            first_three_subscribers.append({
                'firstName': first_name,
                'lastName': last_name,
                'email': email
            })
            is_first_three = True
            logger.info(f"Added subscriber to first three. Total: {len(first_three_subscribers)}")

        # Send message to SQS
        message = {
            'firstName': first_name,
            'lastName': last_name,
            'email': email
        }
        
        if sqs is None:
            logger.error("SQS client is not initialized")
            raise Exception("SQS client is not initialized")
        
        logger.info(f"Attempting to send message to SQS: {message}")
        sqs.send_message(
            QueueUrl=SQS_QUEUE_URL,
            MessageBody=str(message)
        )
        logger.info("Message sent to SQS successfully")

        if is_first_three:
            return jsonify({
                'status': 'success', 
                'message': 'Congratulations! You are one of the first three subscribers and have won a special gift!'
            })
        else:
            return jsonify({
                'status': 'success', 
                'message': 'Thank you for subscribing! Unfortunately, you were not among the first three subscribers to receive a gift.'
            })
    except Exception as e:
        logger.error(f"Error processing form submission: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/messages')
def get_messages():
    try:
        logger.info("Retrieving first three subscribers")
        first_three = get_first_three_subscribers()
        return jsonify({'messages': first_three})
    except Exception as e:
        logger.error(f"Error retrieving messages: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
