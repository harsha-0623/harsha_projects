**CI/CD Driven Flask App with Docker, Kubernetes, Terraform, and Prometheus Monitoring
**

Flask Application with Terraform, CI/CD, Docker, Kubernetes, and Monitoring


Project Overview ==>


This project is a Flask-based Python web application that can be deployed on AWS using Terraform and Docker, while also supporting CI/CD pipelines, Kubernetes deployments, and monitoring with Prometheus. It includes a secure setup with SSL/TLS, and incorporates secrets management using AWS Secrets Manager.

Project Structure ==>


app.py: Simple Python Flask application.

requirements.txt: Lists the Flask dependencies.

Infrastructure ==>


Terraform (terraform/main.tf):

Defines infrastructure for launching an AWS EC2 instance, creating an S3 bucket, setting up IAM roles, and configuring auto-scaling.

CI/CD Pipeline ==>


CI&CD Folder:

Pipeline_script_local: Script for deploying changes locally.

Pipeline_script_server: Script for deploying changes to a remote server.

assignment.sh: Bash script for auto-deployment triggered from Jenkins.


Docker ==>


Dockerfile: Defines how to containerize the Flask application.

docker_run.sh: Bash script to deploy the Docker container.

Kubernetes ==>

Kubernetes Folder:

deployment.yaml: Kubernetes manifest for deploying the application and creating its service.

hpa.yaml: Horizontal Pod Autoscaler configuration to scale the application.

Monitoring & Metrics ==>


Prometheus Folder:

prometheus.yml: Configuration file to start Prometheus service.

app_metrics.py: Sample script to expose metrics for testing purposes.

alert.rules.yml: Defines Prometheus alert rules.


Security ==>


Security Folder:

SSL_TLS.md: Instructions on enabling SSL/TLS for a secure connection.

get_secret.py: Script to retrieve sensitive information (API keys, secrets) from AWS Secrets Manager.

trivy: Documentation and steps to install Trivy for scanning Docker images for vulnerabilities.


Requirements ==>


Python 3.x

Flask

Docker

Kubernetes

Terraform

Jenkins (for CI/CD)

Prometheus (for monitoring)

AWS CLI
