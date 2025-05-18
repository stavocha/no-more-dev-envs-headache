# No More Dev Envs Headaches

A modern web application that demonstrates best practices for cloud-native development and deployment. This project showcases a Flask-based web application with AWS integration, containerization, and infrastructure as code using Terraform and ArgoCD.

## Project Structure

```
.
├── app/                    # Flask application
│   ├── main.py            # Main application logic
│   ├── templates/         # HTML templates
│   ├── Dockerfile         # Container definition
│   └── requirements.txt   # Python dependencies
├── argocd/                # ArgoCD configuration
├── terragrunt/           # Infrastructure as Code
└── .gitignore            # Git ignore rules
```

## Features

- Flask web application with modern UI
- AWS SQS integration for message queuing
- Containerized deployment using Docker
- Infrastructure as Code using Terraform/Terragrunt
- GitOps deployment with ArgoCD
- First-three-subscriber tracking system

## Prerequisites

- Python 3.x
- Docker
- AWS CLI configured with appropriate credentials
- Terraform/Terragrunt
- ArgoCD (for deployment)

## Local Development Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd no-more-dev-envs-headaches
   ```

2. Run the application locally:
   ```bash
   python main.py
   ```

## Docker Build and Run

1. Build the Docker image:
   ```bash
   cd app
   docker build -t no-more-dev-envs-headaches .
   ```

2. Run the container:
   ```bash
   docker run -p 5000:5000 --env-file .env no-more-dev-envs-headaches
   ```

## Infrastructure Deployment

The infrastructure is managed using Terraform/Terragrunt

1. Navigate to the terragrunt directory:
   ```bash
   cd terragrunt
   ```

2. Initialize and apply the infrastructure:
   ```bash
   terragrunt init
   terragrunt run-all  apply
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Contact

This repository is designed and maintained by Stav Ochakovaki.
