# Example STACKIT Cloud Application

This repository contains an example cloud application demonstrating a basic architecture deployed on STACKIT using Kubernetes, Go, Terraform, and PostgreSQL. It serves as a starting point for building cloud-native applications on STACKIT.

## Overview

This application showcases a simple notebook service written in Go that interacts with a PostgreSQL database. The infrastructure is provisioned and managed using Terraform, and the application is deployed and orchestrated on a Kubernetes cluster running on STACKIT.

## Tech Stack

* **Programming Language:** Go
* **Database:** PostgreSQL
* **Infrastructure as Code:** Terraform
* **Container Orchestration:** Kubernetes
* **Cloud Provider:** STACKIT

## Prerequisites

Before you begin, ensure you have the following installed and configured:

* **Go:**  [https://go.dev/dl/](https://go.dev/dl/)
* **Terraform:** [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
* **kubectl:** [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/)
* **STACKIT CLI:**  (Refer to STACKIT documentation for installation instructions) - This is needed for authentication and interacting with STACKIT resources.
* **STACKIT Project:** You need an active STACKIT project to deploy the application.
* **Configured STACKIT Credentials:**  Ensure your STACKIT CLI is configured with valid credentials to access your project.

## Getting Started

Follow these steps to deploy the application:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/hown3d/example-cloud-app.git
    cd example-cloud-app
    ```

2. **Build the application:**

    ```bash
    cd app
    make container
    ```

2. **Apply the Terraform configuration:**

    ```bash
    cd terraform && terraform destroy -var project_id=${YOUR_PROJECT_ID}
    ```

    Type `yes` when prompted to confirm the deployment.  This will provision the Kubernetes cluster, PostgreSQL instance, and other necessary resources on STACKIT.  This process may take some time.

3. **Configure `kubectl`:**

    After the Terraform deployment is complete, configure `kubectl` to connect to your newly created Kubernetes cluster.  The Terraform output will provide the necessary `kubeconfig` information.  You can typically configure `kubectl` using the following command (replace `<path_to_kubeconfig>` with the actual path):

    ```bash
    stackit -p ${YOUR_PROJECT_ID} ske kubeconfig create ${CLUSTER_NAME}
    export KUBECONFIG=<path_to_kubeconfig>
    kubectl get nodes
    ```

    Verify that `kubectl` is correctly configured by listing the nodes in your cluster.

4. **Deploy the application to Kubernetes:**

    * Navigate to the `kubernetes` directory.
    * Apply the Kubernetes manifests:

    ```bash
    cd ../kubernetes
    kubectl apply -f .
    ```

    This will deploy the application's pods, services, and other Kubernetes resources.

5. **Access the application:**

    * Determine the external IP address or hostname of the service.  You can typically find this using:

    ```bash
    kubectl get service notebook -o wide
    ```

    * Access the application in your web browser using the external IP address or hostname of the loadbalancer.

## Cleaning Up

To destroy the infrastructure and remove the application, run the following command from the `terraform` directory:

```bash
cd terraform && terraform destroy -var project_id=${YOUR_PROJECT_ID}
```

Type `yes` when prompted to confirm the destruction.  This will remove all resources created by Terraform.
