# Particle41 DevOps Team Challenge - rukesh1324

This repository contains the solution submission for the Particle41 DevOps Challenge.

## Project Overview

The challenge consists of two main tasks:
1.  Develop a simple web service ("SimpleTimeService"), containerize it using Docker, and publish the image.
2.  Use Terraform to define and deploy Azure cloud infrastructure (ACI pulling from ACR) to host the containerized application.

## Repository Structure

* `/app`: Contains the SimpleTimeService Python Flask application source code (`app.py`, `requirements.txt`) and its `Dockerfile`.
* `/terraform`: Contains Terraform configuration files (`.tf`) for deploying the Azure infrastructure (Task 2).

---

## Task 1: SimpleTimeService Application & Docker

**(Status: Completed Successfully)**

This task involved creating a simple web service, containerizing it with Docker according to best practices (non-root user), and publishing the image.

### Prerequisites (Task 1)

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* A Docker Hub account (optional, to pull the pre-built image)

### Application Details

* **Language:** Python 3
* **Framework:** Flask
* **Functionality:** Returns a JSON response with the current UTC timestamp and the visitor's IP address at the `/` endpoint.
* **Dockerfile:** Configured to run the application as a non-root user (`appuser`) for improved security. Uses a slim Python base image.

### Building the Docker Image

1.  Clone this repository: `git clone https://github.com/rukesh24/particle41-challenge.git`
2.  Navigate to the app directory: `cd particle41-challenge/app`
3.  Build the image (explicitly for linux/amd64 to ensure compatibility):
    ```bash
    # Build using the final tag we used for ACR push (v1.2)
    docker buildx build --platform linux/amd64 -t rukesh2401/simple-time-service:v1.2 .
    ```

### Running the Docker Container Locally

```bash
# Maps port 5001 on your machine to port 5000 in the container
docker run --rm -p 5001:5000 rukesh2401/simple-time-service:v1.2
```

Access the service at http://localhost:5001 in your browser.

Public Docker Hub Image
The image built during troubleshooting (v1.2, platform-specific) was pushed to Docker Hub (and later ACR):
https://hub.docker.com/r/rukesh2401/simple-time-service (Tag: v1.2)


---
## Task 2: Terraform Infrastructure Deployment on Azure

**(Status: Infrastructure Partially Deployed - ACI Inaccessible due to persistent Image Pull Error)**

The goal of this task was to use Terraform to provision Azure infrastructure (Resource Group, ACR, ACI, Managed Identity, Role Assignment) and deploy the containerized application from Task 1, pulled securely from ACR using the ACI's Managed Identity.

### Prerequisites (Task 2)

* Task 1 completed (specifically, the Docker image `rukesh2401/simple-time-service:v1.2` built locally).
* [Terraform](https://developer.hashicorp.com/terraform/downloads) >= v1.0
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos) installed and configured (`az login`).

### Intended Deployment Steps

1.  Clone repository: `git clone https://github.com/rukesh24/particle41-challenge.git`
2.  Navigate to terraform directory: `cd particle41-challenge/terraform`
3.  Initialize Terraform: `terraform init`
4.  Review execution plan: `terraform plan`
5.  Apply configuration (creates RG, ACR, Identity, Role Assign.): `terraform apply` (confirm `yes`)
6.  Log in to created ACR:
    ```bash
    ACR_NAME=$(terraform output -raw acr_name)
    az acr login --name $ACR_NAME
    ```
7.  Tag and Push application image to ACR:
    ```bash
    ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
    # Assuming local image is rukesh2401/simple-time-service:v1.2
    docker tag rukesh2401/simple-time-service:v1.2 $ACR_LOGIN_SERVER/simple-time-service:v1.2
    docker push $ACR_LOGIN_SERVER/simple-time-service:v1.2
    ```
8.  Apply configuration again (creates/updates ACI to use image from ACR): `terraform apply` (confirm `yes`)
9.  Get endpoint: `terraform output container_fqdn`
10. Test endpoint: `http://<FQDN>`

### Final Status & Roadblock

The Terraform configuration (in `/terraform`) defines all necessary resources using Azure Container Registry (ACR) and System Assigned Managed Identity for secure, credential-less image pulls by Azure Container Instances (ACI).

However, the final `terraform apply` step consistently failed when creating the ACI resource (`azurerm_container_group.aci`) with an `InaccessibleImage` error (400 Bad Request or 409 Conflict). This error indicated that ACI could not pull the specified image (`<acr_name>.azurecr.io/simple-time-service:v1.2`) from the ACR instance.

This failure persisted despite extensive troubleshooting:
* Verifying the image (`rukesh2401/simple-time-service:v1.2`) was successfully pushed to the ACR instance created by Terraform.
* Verifying the System Assigned Managed Identity was created for the ACI.
* Verifying via the Azure Portal that the Managed Identity was correctly assigned the `AcrPull` role on the ACR scope.
* Attempting deployment in multiple Azure regions (`centralindia`, `eastus`).
* Performing full `terraform destroy` and clean `apply` cycles.
* Previously attempting deployment via Docker Hub (encountered OS type mismatch errors resolved by platform-specific builds, followed by registry pull errors).
* Previously attempting deployment via ACR using PAT/admin credentials (also encountered registry pull errors).

**Conclusion:** Since the container logs (when the ACI partially started in earlier attempts) showed the application running correctly, the image exists in ACR, and the Managed Identity permissions appear correctly configured in Azure, the persistent `InaccessibleImage` error strongly suggests an underlying Azure platform issue (API inconsistency, networking problem between ACI service and ACR service for this environment, policy interference, or subtle manifest incompatibility) preventing the successful completion of Task 2 as designed.

The final Terraform code reflecting the intended ACR + System Assigned Managed Identity approach is committed in the `/terraform` directory. The deployment fails at the ACI creation step due to the inaccessible image error.

### Terraform Outputs (If Apply Completed Fully)

* `container_fqdn`: The public web address of the running service.
* `container_ipv4_address`: The public IP address.
* `resource_group_name`: The name of the deployed Azure Resource Group.
* `acr_name`: The name of the deployed Azure Container Registry.
* `acr_login_server`: The hostname of the deployed Azure Container Registry.
