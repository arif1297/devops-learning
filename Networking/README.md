# Networking Project — AWS EC2, NGINX & Cloudflare DNS

## Project Overview

For this project, I wanted to put what I'd learnt about networking into practice by hosting a simple website in the cloud and connecting it to my own domain.

I used AWS EC2 to set up an Ubuntu server, installed NGINX to host the webpage, and used Cloudflare to manage the DNS for my domain.

The end goal was to make the default NGINX webpage accessible through my domain, [arifazad.co.uk](http://arifazad.co.uk), rather than having to use the server's public IP address.

### Tools Used

| Tool | What I used it for |
|---|---|
| AWS EC2 | Hosting my Ubuntu virtual machine |
| Ubuntu Server | Running NGINX and Linux commands |
| NGINX | Hosting the webpage |
| Cloudflare | Purchasing my domain and managing DNS |
| AWS Security Groups | Allowing HTTP traffic to my server |
| Linux Terminal | Testing connections and troubleshooting |

## 1. Setting Up AWS EC2

I started by creating an EC2 instance on AWS.

EC2 is essentially a virtual machine hosted on AWS's infrastructure, so instead of using my own hardware, I could run an Ubuntu server in the cloud.

I selected an Ubuntu Server AMI and enabled a public IPv4 address so the server could be reached over the internet.

<img width="1916" height="918" alt="Screenshot From 2026-10-26 21-34-57" src="https://github.com/user-attachments/assets/f0aa9a08-8710-4cfd-87f3-e49901528fa4" />


### Configuring the Security Group

Next, I configured the security group, which acts like a firewall for the EC2 instance.

I allowed HTTP traffic through **port 80**, so people could access the NGINX webpage over the internet.

I also used SSH on **port 22** to allow remote access to the server.

| Port | Protocol | Purpose |
|---|---|---|
| 22 | SSH | Remote access to Ubuntu |
| 80 | HTTP | Accessing the NGINX webpage |

<img width="1919" height="575" alt="image" src="https://github.com/user-attachments/assets/9acbbd58-8e8b-4dd0-965a-8f0f652600c5" />


## 2. Installing NGINX

Once my EC2 instance was running, I connected to the Ubuntu server and installed NGINX.

NGINX is web server software that allows a server to deliver webpages to users.

I started by updating the package list and installing NGINX:

```bash
sudo apt update
sudo apt install nginx -y
```

Then I enabled and started the service:

```bash
sudo systemctl enable --now nginx
```

To check that everything was running, I used:

```bash
sudo systemctl status nginx
```

This returned `active (running)`, confirming that NGINX had started successfully.

<img width="1919" height="763" alt="image" src="https://github.com/user-attachments/assets/bd9d26b4-f089-4f0a-9789-6bcdf6f87783" />

<img width="1920" height="283" alt="image" src="https://github.com/user-attachments/assets/2624dff0-7683-41f5-a4ab-d187d6d09c3b" />



### Testing NGINX

Before connecting my domain, I wanted to make sure the web server was actually working.

I ran:

```bash
curl -I http://127.0.0.1
```

This returned:

```text
HTTP/1.1 200 OK
```

This confirmed that NGINX was responding to requests from inside the server.

I also tested the EC2 public IP from my own computer, which returned the same successful response.

## 3. Setting Up My Domain with Cloudflare

The next step was purchasing a domain and connecting it to my EC2 instance.

I originally tried registering a domain through AWS Route 53, but the registration kept failing. Even after upgrading my AWS account, I couldn't get it to work.

Rather than spending more time trying to get Route 53 working, I decided to use Cloudflare instead.

I purchased **arifazad.co.uk** and configured an A record to point to my EC2 public IPv4 address.

### Configuring the A Record

| Setting | Value |
|---|---|
| Type | A |
| Name | @ |
| IPv4 address | EC2 public IPv4 |
| Proxy status | DNS Only |
| TTL | Auto |

An A record essentially links a domain name to an IPv4 address.

In my case, when someone enters `arifazad.co.uk`, DNS resolves it to my EC2 server's public IP address.

I also changed Cloudflare's proxy setting from **Proxied (orange cloud)** to **DNS Only (grey cloud)**.

This meant Cloudflare would handle the DNS lookup, but the browser would connect directly to my EC2 server rather than going through Cloudflare's proxy.

<img width="1920" height="634" alt="image" src="https://github.com/user-attachments/assets/82b109c8-2766-4ad8-960d-03735000d64b" />


## 4. Testing My Website

After setting up the DNS record, I tested whether the domain was resolving to the correct IP address.

I used:

```bash
nslookup arifazad.co.uk
```

Once DNS was resolving correctly, it returned my EC2 public IPv4 address.

Next, I tested the website itself:

```bash
curl -I http://arifazad.co.uk
```

This returned:

```text
HTTP/1.1 200 OK
Server: nginx/1.28.3 (Ubuntu)
```

Finally, I opened `http://arifazad.co.uk` in Brave and was able to see the default NGINX welcome page.

<img width="1915" height="1080" alt="Screenshot From 2026-10-26 21-34-02" src="https://github.com/user-attachments/assets/b49cac94-4bce-4d2c-b225-4440ff008836" />

## 5. Challenges & Troubleshooting

This was probably the most useful part of the project, as I ran into a few issues and had to troubleshoot them rather than just follow the setup instructions.

### Issue 1 — Website Wouldn't Load in Brave

After getting NGINX running, I tried opening my EC2 public IP in Brave, but the webpage wouldn't load.

At first, I thought there might be something wrong with my AWS networking configuration.

I checked a few things:

- NGINX was active and running.
- HTTP traffic was allowed on port 80.
- Ubuntu's UFW firewall was inactive.
- My subnet had an active route to an Internet Gateway.

Everything looked correct.

I then tested the connection through my Ubuntu terminal using:

```bash
curl -I http://51.20.8.57
```

This returned `HTTP/1.1 200 OK`.

That told me the server was actually accessible and the issue wasn't necessarily with AWS.

It turned out Brave was automatically upgrading HTTP connections to HTTPS.

Since I hadn't configured HTTPS on my NGINX server, the browser couldn't establish the connection.

For testing, I disabled the automatic HTTPS upgrade and was able to access the webpage over HTTP.

**What I learnt:** Just because a webpage isn't loading in a browser doesn't mean the server is down. Testing through the terminal can help narrow down where the issue is.

### Issue 2 — My Domain Wasn't Resolving

After configuring Cloudflare, I ran:

```bash
curl -I http://arifazad.co.uk
```

But instead of getting a successful response, I received:

```text
curl: (6) Could not resolve host: arifazad.co.uk
```

This meant my computer couldn't find the IP address associated with my domain.

To investigate, I queried Cloudflare's public DNS resolver directly:

```bash
nslookup arifazad.co.uk 1.1.1.1
```

Interestingly, this worked and returned my EC2 public IP.

So Cloudflare's DNS appeared to be working, but my computer still couldn't resolve the domain normally.

Next, I tried bypassing DNS resolution using:

```bash
curl -I --resolve arifazad.co.uk:80:51.20.8.57 http://arifazad.co.uk
```

This returned `HTTP/1.1 200 OK`.

This was useful because it confirmed the connection to NGINX worked when I manually supplied the server's IP address.

<img width="948" height="1023" alt="Screenshot From 2026-10-26 21-33-33" src="https://github.com/user-attachments/assets/fe9ac0d1-879c-4251-bc2a-21668f0338e3" />


### Issue 3 — Checking My DNS Configuration

Because I use AdGuard Home on my personal homelab, I initially thought it might have been interfering with DNS.

However, I couldn't find any requests for my domain in its query log.

I then checked my Ubuntu PC's DNS configuration using:

```bash
resolvectl status
```

This showed that my computer was using my router (`192.168.1.254`) as its current IPv4 DNS server.

I tested the router directly:

```bash
nslookup arifazad.co.uk 192.168.1.254
```

This successfully returned my EC2 public IP.

At this point, both Cloudflare's DNS resolver and my router could resolve the domain, but Ubuntu's normal DNS lookup was still failing.

That suggested it could be a local DNS caching issue.

### Fix — Clearing the DNS Cache

I cleared Ubuntu's DNS cache using:

```bash
sudo resolvectl flush-caches
```

Then I tried again:

```bash
nslookup arifazad.co.uk
```

This time it returned the correct IP address.

Finally, I ran:

```bash
curl -I http://arifazad.co.uk
```

And got:

```text
HTTP/1.1 200 OK
```

This confirmed the issue had been resolved.

The most likely cause was an outdated or cached DNS response on my Ubuntu PC.

<img width="948" height="1023" alt="Screenshot From 2026-10-26 21-33-46" src="https://github.com/user-attachments/assets/1f35fb00-03ef-4e66-946f-550ea2d2d90d" />


**What I learnt:** DNS issues can happen at different stages. Even if the DNS record is configured correctly, a local resolver might still return outdated information. Testing different DNS servers helped me narrow down the problem.

## 6. What I Learnt

This project helped me understand how different networking components work together in practice.

Some of the main things I learnt were:

- **Cloud networking:** How AWS EC2 allows me to run a server without needing my own physical hardware.
- **DNS:** How A records link domain names to IPv4 addresses.
- **Security groups:** How firewall rules control which connections are allowed to reach a server.
- **HTTP and HTTPS:** The difference between unencrypted HTTP connections and encrypted HTTPS connections.
- **Web servers:** How NGINX receives HTTP requests and serves webpages.
- **Network troubleshooting:** How to use `curl`, `nslookup` and `resolvectl` to identify connectivity issues.

One of the biggest takeaways was learning to troubleshoot step by step.

Rather than changing multiple settings at once, I found it much more useful to test different parts of the connection individually to narrow down the problem.

## 7. Final Result

By the end of the project, I had successfully deployed an NGINX web server on AWS EC2 and connected it to my custom domain using Cloudflare DNS.

I was able to access the default NGINX webpage at:

**http://arifazad.co.uk**

The project gave me some practical experience with AWS, Linux, DNS, firewalls and troubleshooting.
