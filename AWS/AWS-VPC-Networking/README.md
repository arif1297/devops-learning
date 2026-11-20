# AWS VPC & Networking Infrastructure

## Project Overview

This project was completed as part of my DevOps learning journey, focusing on designing, deploying and testing a custom network infrastructure using Amazon Web Services (AWS).

The objective was to gain practical experience with AWS networking, including VPCs, public and private subnets, internet connectivity, routing, security groups and EC2 instances.

The infrastructure was configured to allow controlled access to a public EC2 instance while keeping a private EC2 instance isolated from direct internet access.

## Project Objectives

The assignment involved the following requirements:

1. **VPC & Subnets**
   - Create a custom VPC using the CIDR block `10.0.0.0/16`.
   - Create one public subnet and one private subnet.

2. **Internet Connectivity**
   - Create and attach an Internet Gateway.
   - Allocate an Elastic IP address.
   - Deploy a public NAT Gateway to provide outbound internet access for private resources.

3. **Route Tables**
   - Create separate public and private route tables.
   - Configure the public subnet to route internet-bound traffic through the Internet Gateway.
   - Configure the private subnet to route internet-bound traffic through the NAT Gateway.

4. **EC2 Instances**
   - Launch one EC2 instance in the public subnet.
   - Launch another EC2 instance in the private subnet without a public IPv4 address.

5. **Network Security**
   - Configure security groups to control inbound and outbound traffic.
   - Restrict SSH and HTTP access to the public EC2 instance.
   - Allow internal SSH access to the private EC2 instance from the public EC2 security group.

6. **Testing & Verification**
   - Verify SSH connectivity to the public EC2 instance.
   - Test internal connectivity between the public and private EC2 instances.
   - Verify outbound internet access from the private EC2 instance.

**Below is a diagram of the planned infrastrucutre:**

<img width="864" height="956" alt="image" src="https://github.com/user-attachments/assets/88db52fd-5c75-4258-9aaa-14b0c7448579" />


---

## Infrastructure Configuration

### 1. VPC & Subnets

Created a custom VPC with the CIDR block `10.0.0.0/16`.

Within the VPC, I configured two subnets:

- **Public subnet:** `10.0.1.0/24`
- **Private subnet:** `10.0.2.0/24`

The public subnet was designed to host resources requiring internet connectivity, while the private subnet was used for resources that should not be directly accessible from the internet.

### 2. Internet Gateway & NAT Gateway

Created and attached an Internet Gateway to the custom VPC to enable internet connectivity for resources in the public subnet.

I also deployed a public NAT Gateway within the public subnet to allow resources in the private subnet to initiate outbound internet connections without requiring their own public IP addresses.

The NAT Gateway was assigned an Elastic IP address.

### 3. Route Tables

Created separate route tables for the public and private subnets.

| Route Table | Destination | Target |
|---|---|---|
| Public | `0.0.0.0/0` | Internet Gateway |
| Private | `0.0.0.0/0` | NAT Gateway |

Each route table was associated with its corresponding subnet.

This configuration allows public resources to communicate with the internet while private resources use the NAT Gateway for outbound connectivity.

**VPC Resource Map**

<img width="1173" height="275" alt="Screenshot From 2026-11-20 16-17-41" src="https://github.com/user-attachments/assets/71e09271-6b72-45ba-906b-88e729820194" />


### 4. EC2 Instances

Deployed two Amazon Linux EC2 instances within the custom VPC.

| Configuration | Public EC2 | Private EC2 |
|---|---|---|
| Subnet | Public | Private |
| Private IPv4 | `10.0.1.243` | `10.0.2.181` |
| Public IPv4 | Assigned | Not assigned |
| Operating System | Amazon Linux | Amazon Linux |
| Instance Type | t3.micro | t3.micro |

The public instance was configured to provide an entry point for administrative access, while the private instance was deployed without a public IP address.

Both instances were launched without SSH key pairs, so alternative AWS management methods were used during testing.

**EC2 Instances Overview**

<img width="1021" height="85" alt="Screenshot From 2026-11-20 16-23-20" src="https://github.com/user-attachments/assets/2e89fa22-260e-4c2b-9052-c3e35d44138b" />


### 5. Security Groups

Configured separate security groups to control access to each instance.

**Public EC2 Security Group (`public-sg`)**

- SSH (port 22): Restricted to authorized source IP addresses.
- HTTP (port 80): Restricted to my public IP address.

**Public Security Group**

<img width="1125" height="210" alt="Screenshot From 2026-11-20 16-19-52" src="https://github.com/user-attachments/assets/90920c3e-c8d4-40b5-966a-799b08cb5040" />


**Private EC2 Security Group**

- SSH (port 22): Allowed only from `public-sg`.
- No direct public SSH access configured.

Using a security group reference rather than a fixed IP address allows authorized instances associated with `public-sg` to communicate with the private EC2.

**Private Security Group**

<img width="1118" height="170" alt="Screenshot From 2026-11-20 16-20-25" src="https://github.com/user-attachments/assets/04dffa76-8338-46d2-97ad-d8bd2aa1e012" />


---

## Testing & Verification

After deploying the infrastructure, I performed connectivity tests to verify that the network behaved as intended.

### Test 1 — Public EC2 SSH Connectivity

**Objective:** Verify that the public EC2 instance could be accessed remotely.

Connected to the public EC2 using AWS EC2 Instance Connect.

The connection was successful, confirming that the instance was reachable and that the necessary network routing and security group permissions allowed SSH access.

**Result:** Passed

**Public EC2 SSH Connection**

<img width="664" height="307" alt="Screenshot From 2026-11-20 16-05-01" src="https://github.com/user-attachments/assets/5724caec-5c68-483d-8552-b23cb2f5f76c" />


### Test 2 — Internal SSH Connectivity

**Objective:** Verify that the public EC2 could communicate with the private EC2 over SSH.

From the public EC2 instance, I executed:

```bash
ssh ec2-user@10.0.2.181
```

The connection returned:

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

Although authentication was unsuccessful, the response confirmed that the public EC2 had reached the private EC2's SSH service.

This demonstrated that internal SSH connectivity was functioning. A successful authenticated SSH session through the public instance was not established.

**Result:** Network connectivity passed; SSH authentication not completed.

**Internal SSH Connectivity**

<img width="728" height="67" alt="Screenshot From 2026-11-20 16-05-45" src="https://github.com/user-attachments/assets/bedc38c0-4bb1-4e05-8516-b160edbf8273" />


### Test 3 — Private EC2 Outbound Internet Connectivity

**Objective:** Verify that the private EC2 could access the internet through the NAT Gateway without having a public IPv4 address.

Connected to the private EC2 using AWS Systems Manager Session Manager.

Executed:

```bash
curl -I https://www.google.com
```

The command returned a successful HTTP response, confirming that the private EC2 could reach an external website.

With the private subnet configured to route outbound internet traffic through the NAT Gateway, this provided evidence that the outbound networking configuration was functioning correctly.

**Result:** Passed

**Private EC2 Internet Connectivity**

<img width="1368" height="360" alt="Screenshot From 2026-11-20 16-16-02" src="https://github.com/user-attachments/assets/766dee11-f2a7-41fd-b649-edfb1bc46c86" />


---

## Troubleshooting & Challenges

### 1. Elastic IP Configuration

**Issue:** Initially, I was unsure whether the NAT Gateway had been assigned the Elastic IP address I allocated manually.

**Investigation:**
- Checked the NAT Gateway's connectivity type and public IPv4 address.
- Reviewed the Elastic IP addresses allocated within the VPC console.
- Identified that AWS had allocated a separate Elastic IP during NAT Gateway creation.

**Resolution:** Confirmed that the NAT Gateway already had an Elastic IP assigned and did not require an additional address.

**What I learned:** Public NAT Gateways require an Elastic IP, and AWS allows one to be allocated during gateway creation.

### 2. EC2 Instance Connect Failure

**Issue:** My initial attempt to connect to the public EC2 through EC2 Instance Connect failed with an SSH connection error.

**Investigation:**
- Reviewed the public EC2 security group's inbound rules.
- Investigated the source IP restrictions for SSH.
- Identified that I had selected an incorrect IPv6 source when configuring the connection.

**Resolution:** Corrected the security group source configuration and successfully connected to the public EC2 using EC2 Instance Connect.

**What I learned:** Security groups must allow traffic from the correct source addresses. Incorrect inbound rules can prevent access even when an instance is running and its routing is configured correctly.

### 3. SSH Authentication Failure

**Issue:** The SSH connection from the public EC2 to the private EC2 returned a permission denied error.

**Cause:** The private EC2 had been launched without an SSH key pair, and no accepted authentication credentials were available for the connection.

**Resolution:** Confirmed that the SSH service was reachable, distinguishing network connectivity from authentication. Used AWS Systems Manager Session Manager to access the private EC2 for further testing.

**What I learned:** A successful network connection does not automatically mean authentication will succeed. Network access and user authentication are separate security controls.

---

## Key Learning Outcomes

Through this assignment, I gained practical experience in:

- Designing a custom AWS VPC with public and private subnets.
- Understanding how Internet Gateways and NAT Gateways serve different purposes.
- Configuring route tables to control network traffic.
- Deploying EC2 instances into specific subnets.
- Using security groups to restrict access between resources.
- Understanding the difference between network connectivity and SSH authentication.
- Managing EC2 instances using EC2 Instance Connect and AWS Systems Manager.
- Troubleshooting networking and access issues.
- Verifying infrastructure functionality through practical connectivity tests.

## Project Summary

This project provided hands-on experience in deploying and testing a custom AWS networking environment.

I successfully configured a VPC with public and private subnets, internet connectivity, routing, EC2 instances and security groups. I also verified public instance access, internal SSH connectivity and outbound internet access from the private subnet.

The assignment strengthened my understanding of how AWS networking components work together and the importance of testing and troubleshooting infrastructure rather than assuming a successful deployment means everything is functioning correctly.
