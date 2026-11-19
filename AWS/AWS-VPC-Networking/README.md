# AWS VPC & Networking Infrastructure

**Status: In Progress**

## Project Overview

This project is part of my DevOps learning journey, focusing on designing and configuring a custom network infrastructure using Amazon Web Services (AWS).

The aim is to gain hands-on experience with AWS networking, including VPCs, public and private subnets, internet connectivity, routing and network security.

## Project Objectives

The assignment involves building a secure AWS network infrastructure with the following requirements:

1. **VPC & Subnets**
   - Create a custom VPC using `10.0.0.0/16`.
   - Create one public subnet and one private subnet.

2. **Internet Connectivity**
   - Create and attach an Internet Gateway (IGW).
   - Allocate an Elastic IP address.
   - Deploy a NAT Gateway in the public subnet to provide outbound internet access for private resources.

3. **Route Tables**
   - Create separate public and private route tables.
   - Configure the public route table to direct internet traffic through the Internet Gateway.
   - Configure the private route table to direct internet traffic through the NAT Gateway.
   - Associate each route table with its respective subnet.

4. **EC2 Instances**
   - Launch a public EC2 instance with a public IPv4 address.
   - Launch a private EC2 instance without a public IPv4 address.

5. **Network Security**
   - Configure security groups to control inbound and outbound traffic.
   - Restrict SSH and HTTP access to the public EC2 instance to my IP address.
   - Allow only internal access to the private EC2 instance.
   - Configure secure access to the private instance through a bastion host.

**Below is a diagram for the planned infrastructure:**

<img width="820" height="901" alt="image" src="https://github.com/user-attachments/assets/aa8afb5a-6cf6-4d3d-9e5b-9bd048cac4ee" />


## Progress So Far

### 1. VPC & Subnets — Completed
- Created a custom VPC.
- Created separate public and private subnets.

### 2. Internet Connectivity — In Progress
- Created an Internet Gateway.
- Allocated an Elastic IP address.
- Created a public NAT Gateway.
- Currently verifying the NAT Gateway's Elastic IP configuration.

### 3. Route Tables — Configured
- Created separate route tables for public and private subnets.
- Configured the public route table to use the Internet Gateway.
- Configured the private route table to use the NAT Gateway.
- Associated both route tables with their respective subnets.

*Routing and internet connectivity are yet to be tested.*

---

**Project Status:** In Progress — EC2 deployment, security configuration and connectivity testing are still pending.

This README will be updated as the remaining infrastructure is deployed and tested.
