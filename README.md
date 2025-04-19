# Particle41 DevOps Team Challenge - Rukesh Dasari

This repository contains the solution for the Particle41 DevOps Challenge.

## Project Structure

* `/app`: Contains the SimpleTimeService Python Flask application and its Dockerfile.
* `/terraform`: Contains Terraform code for cloud infrastructure (Task 2 - TODO).

## Task 1: SimpleTimeService Application & Docker

This task involved creating a simple web service, containerizing it with Docker, and publishing the image.

### Prerequisites

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* A Docker Hub account (optional, to pull the pre-built image)

### Application Details

* Language: Python 3
* Framework: Flask
* Functionality: Returns a JSON response with the current UTC timestamp and the visitor's IP address at the `/` endpoint.

### Building the Docker Image

1.  Clone this repository: `git clone https://github.com/rukesh24/particle41-challenge.git`
2.  Navigate to the app directory: `cd particle41-challenge/app`
3.  Build the image: `docker build -t simple-time-service:latest .`

### Running the Docker Container

* **Option 1: Run the locally built image:**
    ```bash
    # Maps port 5001 on your machine to port 5000 in the container
    docker run --rm -p 5001:5000 simple-time-service:latest
    ```
    Access the service at `http://localhost:5001` in your browser.

* **Option 2: Run the pre-built image from Docker Hub:**
    ```bash
    # Maps port 5001 on your machine to port 5000 in the container
    docker run --rm -p 5001:5000 rukesh2401/simple-time-service:latest
    ```
    Access the service at `http://localhost:5001` in your browser.

### Public Docker Hub Image

The pre-built image is available on Docker Hub at:
[https://hub.docker.com/r/rukesh2401/simple-time-service](https://hub.docker.com/r/rukesh2401/simple-time-service)

---
*(Task 2 Documentation will go here later)*