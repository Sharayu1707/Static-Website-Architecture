# static-website-project

# Overview :

This project deploys a scalable static website on AWS using Terraform and Jenkins. An Application Load Balancer distributes traffic across EC2 instances in an Auto Scaling Group. When new code is pushed to GitHub, Jenkins automatically rebuilds and updates the infrastructure. CloudWatch monitors CPU usage and triggers an SNS email alert during high load, while the ASG automatically scales the number of instances to handle traffic. This setup demonstrates automated deployment, monitoring, and auto-scaling for a highly available website.

# Features

* Automated infrastructure deployment using Terraform

* CI/CD pipeline with Jenkins for continuous updates

* Auto Scaling Group for automatic scale-out and scale-in

* Application Load Balancer for high availability

* User Data installs Nginx and pulls latest website code

* CloudWatch CPU monitoring and alarms

* SNS email alerts during high CPU usage

* Fully automated, scalable, and highly available static website

# Tools Used

Tool	        Purpose

Terraform -> Provision AWS infrastructure 

Jenkins -> CI/CD automation

AWS EC2 ->	Hosts static website using Nginx

ALB	-> Load balancing

ASG	-> Auto-scaling based on CPU

CloudWatch -> Monitoring & Alarms

SNS ->	Email notifications

GitHub -> Version control & webhook trigger

# Step to deployment :

## Step 1 : (Fork & Clone the Repository)

Fork your static website repo on GitHub

Clone it to your local system

Add your terraform folder inside the project

## Step 2 : (Terraform Setup)

Inside the terraform/ folder:

main.tf

user_data.sh
 
variables.tf

Output.tf

Run:

terraform init

terraform plan

terraform apply --auto-approve


![Architecture](images/Screenshot%20(139).png)

## Step 3 : (Jenkins Setup)

Install Jenkins on an EC2 instance

Install required plugins:

Git

Pipeline

Terraform plugin (optional)

![Architecture](images/Screenshot%20(125).png)

## Step 4 : (Create Jenkins Pipeline)

Create a new Pipeline job

Add your Jenkinsfile

Set GitHub repo URL

Jenkins now:

Pulls latest code

Updates launch template

Runs Terraform apply

Refreshes ASG instances

## Step 5 : (Validate Deployment)

Get ALB DNS from Terraform output

Open in browser:

http://<alb-dns>

You should see your website live

![Architecture](images/Screenshot%20(138).png)

# Conclusion

This project demonstrates a complete production-grade auto-scaling architecture using AWS and DevOps tools.

It shows the mastery of CI/CD, Terraform automation, monitoring, and scaling.

