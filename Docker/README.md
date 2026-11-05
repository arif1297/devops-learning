# CoderCo Containers Challenge — Flask & Redis

## Project Overview

This project is part of my DevOps bootcamp's **Containers and Docker module**.

The challenge was to build a multi-container application using Python Flask and Redis, containerize the application with Docker, and use Docker Compose to manage the services.

The application consists of two pages:

- `/` — Displays a welcome message.
- `/count` — Displays a visitor counter that increases every time the page is refreshed.

The main goal was to get hands-on experience with Dockerfiles, images, containers, networking, port mapping, and Docker Compose.

I used the [CoderCo Containers Intro repository](https://github.com/codercohq/containers-intro) as my starting point.

---

## Tools Used

| Technology | Purpose |
|---|---|
| Python | Programming language for the application |
| Flask | Framework used to build the web application |
| Redis | Stores and increments the visitor count |
| Docker | Builds images and runs containers |
| Docker Compose | Manages multiple containers together |
| Git & GitHub | Version control and documentation |
| Ubuntu | Development environment |
| VS Code | Code editor |

---

## How the Application Works

The application uses two separate containers:

**Flask Container**
- Hosts the web application.
- Handles requests from the browser.
- Communicates with Redis to update the visitor count.
- Displays the updated count.

**Redis Container**
- Stores the visitor count as a key-value pair.
- Increases the count whenever Flask requests it.
- Returns the updated number to Flask.

### Application Architecture

```text
           User / Browser
                 |
                 | localhost:8080
                 |
                 v
          Flask Container
             Port 5001
                 |
                 | Docker Network
                 |
                 v
          Redis Container
             Port 6379
                 |
                 v
          Stores Visit Count
```

When someone visits `/count`, Flask sends a request to Redis to increment the stored value. Redis updates the count and returns the new number, which Flask displays on the webpage.

---

## Step 1: Setting Up the Project

I started by cloning the CoderCo starter repository:

```bash
git clone https://github.com/codercohq/containers-intro.git
```

The repository contained starter files including `app.py`, a `Dockerfile`, and `requirements.txt`.

I looked through these files to understand what had already been provided and what I needed to add.

I later created a separate `assignment` folder to keep my completed project separate from the original starter files.

### Project Structure

```text
assignment/
├── app.py
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── README.md
```

---

## Step 2: Setting Up the Flask Application

The starter repository already had a basic Flask homepage.

I needed to add a second route called `/count` to display the visitor count.

### Setting Up a Python Virtual Environment

I created a virtual environment:

```bash
python3 -m venv .venv
```

Then activated it:

```bash
source .venv/bin/activate
```

This allowed me to install Python packages specifically for this project rather than installing them system-wide.

I installed Flask and the Redis Python client:

```bash
python3 -m pip install flask redis
```

To verify the installations, I used:

```bash
python3 -m pip show flask
python3 -m pip show redis
```

### Configuring the Flask Routes

The application has two routes.

**Homepage (`/`)**

Displays a simple welcome message.

**Visitor Counter (`/count`)**

```python
@app.route('/count')
def count():
    visits = redis_client.incr('visits')
    return f'Visitor Count: {visits}'
```

The `visits` variable stores the updated number returned by Redis.

The `redis_client.incr('visits')` instruction tells Redis to increase the value stored under the `visits` key by one.

The return statement then displays that number on the webpage.

### Testing Flask Locally

Before using Docker, I ran Flask directly on Ubuntu:

```bash
python3 app.py
```

I then tested both routes in my browser to confirm they were working.

---

## Step 3: Setting Up Redis

Redis is a key-value database that can store information using a key and its associated value.

For example:

```text
Key: visits
Value: 5
```

Each time someone visits `/count`, the value increases by one.

I initially ran Redis manually using Docker:

```bash
docker run -d --name redis-server -p 6379:6379 redis
```

### Command Breakdown

- `docker run` — Creates and starts a container from an image.
- `-d` — Runs the container in the background.
- `--name redis-server` — Gives the container a name.
- `-p 6379:6379` — Maps the host port to the Redis container port.
- `redis` — Uses the official Redis image.

I checked that the container was running using:

```bash
docker ps
```

At this stage, Flask was running directly on Ubuntu, while Redis was running inside Docker.

Using the Redis Python client, Flask was able to communicate with Redis through `localhost:6379`.

I tested `/count` and confirmed that refreshing the page increased the counter.

---

## Step 4: Dockerizing the Flask Application

Once Flask and Redis were communicating successfully, I moved on to containerizing Flask.

I used a Dockerfile to define how the Flask image should be built.

### Dockerfile

```dockerfile
FROM python:3.11-alpine

WORKDIR /app

COPY app.py .

RUN pip install flask redis

EXPOSE 5001

CMD ["python", "app.py"]
```

### Dockerfile Breakdown

**FROM**

```dockerfile
FROM python:3.11-alpine
```

Uses a lightweight Python 3.11 Alpine image as the starting point.

**WORKDIR**

```dockerfile
WORKDIR /app
```

Creates or selects `/app` as the working directory inside the container.

**COPY**

```dockerfile
COPY app.py .
```

Copies the Flask application file from the build context into the container's working directory.

**RUN**

```dockerfile
RUN pip install flask redis
```

Installs the Python packages required by the application during the image build.

**EXPOSE**

```dockerfile
EXPOSE 5001
```

Documents that the Flask application uses port 5001 inside the container.

This does not automatically publish the port to the host machine.

**CMD**

```dockerfile
CMD ["python", "app.py"]
```

Defines the default command used to start the Flask application when the container runs.

### Building the Docker Image

I built the Flask image using:

```bash
docker build -t flask-app .
```

- `docker build` — Builds a Docker image.
- `-t flask-app` — Tags the image with the name `flask-app`.
- `.` — Uses the current directory as the build context.

I verified that the image existed using:

```bash
docker images
```

### Running the Flask Container

I practiced starting the Flask container manually using:

```bash
docker run --name flask-container -p 8080:5001 flask-app
```

This maps port 8080 on my computer to port 5001 inside the Flask container.

---

## Step 5: Setting Up Docker Compose

Instead of manually running and connecting the containers, I used Docker Compose to manage the application.

Docker Compose allows multiple services to be defined in a single YAML configuration file.

### docker-compose.yml

```yaml
services:
  flask:
    build: .
    ports:
      - "8080:5001"
    environment:
      REDIS_HOST: redis
    depends_on:
      - redis

  redis:
    image: redis
```

### Configuration Breakdown

**services**

Defines the services that make up the application.

In this project, there are two services: `flask` and `redis`.

**build: .**

Tells Compose to build the Flask image using the Dockerfile in the current directory.

**ports**

Maps port 8080 on the host machine to port 5001 inside the Flask container.

**environment**

```yaml
environment:
  REDIS_HOST: redis
```

Defines an environment variable that the Flask application can use to identify the Redis hostname.

The Python application must explicitly read this variable for it to take effect.

**depends_on**

Tells Docker Compose to start the Redis service before the Flask service.

This controls startup order but does not automatically guarantee that Redis is ready to accept connections.

**image: redis**

Uses the official Redis image from Docker Hub.

For this implementation, I used the existing Redis image rather than creating a custom Redis Dockerfile.

### Starting the Application

I started the application using:

```bash
docker compose up -d --build
```

- `up` — Creates and starts the services.
- `-d` — Runs them in the background.
- `--build` — Rebuilds images for services configured with `build`.

I checked the running containers using:

```bash
docker ps
```

### Screenshot — Running Containers

<img width="1420" height="134" alt="Screenshot From 2026-11-05 19-59-42" src="https://github.com/user-attachments/assets/f50b21d0-e93a-4cff-92b7-91fb8132bde2" />


### Screenshot — Docker Compose Configuration

<img width="754" height="384" alt="Screenshot From 2026-11-05 19-59-59" src="https://github.com/user-attachments/assets/1312a1eb-ed9d-4c33-a12c-bab035b27948" />


---

## Step 6: Testing the Application

Once both containers were running, I tested the application through my browser.

### Test 1: Homepage

I opened:

```text
http://localhost:8080
```

The browser successfully displayed the Flask welcome message.

This confirmed that the Flask container was running and accessible through the configured port mapping.

### Screenshot — Homepage

<img width="1920" height="1080" alt="Screenshot From 2026-11-05 19-58-38" src="https://github.com/user-attachments/assets/4237ea85-0342-40cf-876e-055fca4c1afb" />


### Test 2: Visitor Counter

I then opened:

```text
http://localhost:8080/count
```

Refreshing the page increased the visitor count.

For example:

```text
Visitor Count: 1
Visitor Count: 2
Visitor Count: 3
```

This confirmed that Flask could communicate with Redis, increment the stored value, and display the result.

### Screenshot — Visitor Counter

<img width="1920" height="1080" alt="Screenshot From 2026-11-05 19-58-31" src="https://github.com/user-attachments/assets/68abbf1f-cf0f-4522-a408-da7c76b6262c" />


---

## Step 7: Troubleshooting

I ran into a few issues while completing the challenge, which helped me understand Docker and networking better.

### Issue 1: Flask Module Not Found

**Problem:**

When I first tried to run `app.py`, Python returned:

```text
ModuleNotFoundError: No module named 'flask'
```

**Cause:**

Flask was not installed in the Python environment I was using.

**Solution:**

I created and activated a Python virtual environment and installed Flask using pip.

**What I learned:**

Python packages need to be installed in the environment being used to run the application.

### Issue 2: Multiple Containers From Manual Docker Commands and Compose

**Problem:**

I originally created containers manually using `docker run`.

Later, when I switched to Docker Compose, it created another set of containers with names based on the project and service names.

This caused confusion because I wasn't sure which containers belonged to the final assignment.

**Solution:**

I separated my assignment files into their own folder and stopped the previous Compose project using:

```bash
docker compose -f ../containers-intro/docker-compose.yml down
```

I then started the application from my dedicated assignment folder.

**What I learned:**

Docker Compose groups containers under a project and gives them names based on the project and service.

It is important to understand which containers belong to which project when troubleshooting.

### Issue 3: Internal Server Error on `/count`

**Problem:**

The homepage loaded successfully, but visiting `/count` returned:

```text
Internal Server Error
```

This meant the Flask application was running, but something was failing when the counter route was executed.

**Troubleshooting:**

I checked the Flask container logs:

```bash
docker compose logs flask --tail=30
```

The logs showed a connection error similar to:

```text
Error 111 connecting to localhost:6379
Connection refused
```

**Cause:**

The Redis connection inside `app.py` was configured with:

```python
host='localhost'
```

This worked when Flask was running directly on Ubuntu and Redis was accessible through a published port.

However, once Flask was running inside its own container, `localhost` referred to the Flask container itself.

Redis was running in a different container.

**Solution:**

I changed the Redis connection hostname to:

```python
host='redis'
```

The hostname `redis` matches the Redis service name defined in Docker Compose.

Both services are connected to the same Docker Compose network, allowing Flask to communicate with Redis using that name.

After saving the changes, I rebuilt and restarted the application:

```bash
docker compose up -d --build
```

I tested `/count` again, and the visitor count successfully increased whenever I refreshed the page.

**What I learned:**

This was probably the most useful troubleshooting experience in the project.

I learned that:

- `localhost` refers to the current machine or container.
- Containers on the same Compose network can communicate using service names.
- Container logs help identify what is causing application errors.
- Changes to application code copied into an image require rebuilding that image before the changes appear in the container.

---

## Key Takeaways

This project helped me put together several Docker concepts that I'd previously learned individually.

My main takeaways were:

1. **Dockerfiles build images, and images are used to create containers.**
2. **Docker Compose makes managing multiple containers much easier.** Instead of manually starting each container and configuring its networking, I can define everything in one file.
3. **Port mapping allows applications inside containers to be accessed from the host machine.**
4. **Containers have their own networking environments.** Using `localhost` inside one container does not automatically connect it to another container.
5. **Service names allow containers to communicate over a Docker Compose network.**
6. **Logs are important for troubleshooting.** Checking the Flask logs helped me identify the Redis connection issue.
7. **Rebuilding images is necessary when application code inside the image changes.**

## Conclusion

This challenge was a useful way to apply the Docker concepts I'd been studying.

I started with a simple Flask application, connected it to Redis, containerized Flask, and used Docker Compose to manage the two services.

I also ran into a networking issue that initially stopped the visitor counter from working. Troubleshooting this helped me better understand how containers communicate.

By the end of the project, I had a working multi-container application with a Flask homepage and a Redis-backed visitor counter.

The biggest thing I took away from this assignment was understanding **how Docker networking and Docker Compose work together**, rather than just getting the application running.

---


