# AWS Transfer for SFTP Data Upload Project

This project aims to provide a secure and efficient mechanism for multiple marketing agencies to upload data files (CSV, Excel, JSON) to our AWS S3 data lake using AWS Transfer for SFTP. The solution ensures data security, scalability, and operational reliability through AWS-managed services and Infrastructure as Code (IaC) principles.

## Project Overview

  The project leverages the following AWS services and components:
  
  - AWS Transfer for SFTP**: Provides secure SFTP access for agencies to upload files securely to AWS.
  - AWS Lambda**: Monitors the S3 bucket for incoming file uploads and triggers alerts for missing data.
  - AWS S3**: Acts as a central data lake to store uploaded files with versioning enabled for data integrity.
  - Terraform**: Implements Infrastructure as Code (IaC) to automate provisioning and management of AWS resources.
  - Amazon SNS**: Sends alerts to the SRE team for any missing data uploads, ensuring timely responses.

## Features

  - Secure File Uploads**: Agencies upload files securely via SFTP using their designated AWS Transfer for SFTP user accounts.
  - Monitoring and Alerting**: AWS Lambda function monitors S3 for expected file uploads and alerts via SNS in case of missing data.
  - Scalable and Reliable**: Leveraging AWS cloud scalability and reliability for handling variable data volumes and ensuring     
    operational continuity.

## Getting Started

To get started with this project, follow these steps:

1. Prerequisites**:
   - AWS account with appropriate permissions to create IAM roles, S3 buckets, AWS Transfer for SFTP resources, and Lambda functions.
   - Install Terraform (version 0.12 or higher) on your local machine.

2. Setup AWS Credentials**:
   - Ensure your AWS credentials are configured either through environment variables or AWS CLI configuration.

3. **Clone the Repository**:
   - git clone https://github.com/your/repository.git
   - cd repository-directory

4.Configure Terraform Variables:

  - Copy terraform.tfvars.example to terraform.tfvars and update the variables with your specific values.
    
5.Deploy Infrastructure:

  - terraform init
  - terraform apply -var-file="terraform.tfvars"
    
6.Accessing the SFTP Endpoint:

  - Once deployed, you will receive the SFTP server hostname (e.g., s-51c4b380aa6a4d12a.server.transfer.eu-west-1.amazonaws.com). Use        this hostname to configure your SFTP client for file uploads.
