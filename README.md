<h1 align="center">🦅 Project Phoenix</h1>

<p align="center">
  <b>Migrating a Legacy Monolith to a Secure, Multi-AZ Microservices Platform on Amazon EKS</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white" />
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white" />
  <img src="https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white" />
</p>

---

## 📖 Overview
Project Phoenix is a production-grade infrastructure repository demonstrating the end-to-end migration of a legacy application to a modern cloud-native stack. It features **100% Infrastructure as Code (IaC)**, keyless CI/CD pipelines via OIDC federation, and a hardened zero-downtime deployment strategy.

## 🏗️ Architecture Flow

```mermaid
graph TD
    %% CI/CD Flow
    subgraph "GitHub Actions (OIDC Federated)"
        PR[Pull Request] --> CI[CI Pipeline: Trivy Scan & Docker Build]
        CI --> Push[Push Image to ECR]
        Merge[Merge to Main] --> CD[CD Pipeline: Terraform Apply & Helm Upgrade]
    end

    %% AWS Infrastructure
    subgraph "AWS Cloud (Provisioned via Terraform)"
        VPC[VPC - 3 AZs]
        
        subgraph "Public Subnets"
            ALB[AWS Load Balancer]
            NAT[NAT Gateways]
        end
        
        subgraph "Private Subnets"
            EKS[EKS Cluster v1.30]
            Bastion[Bastion Host - SSM Only]
            GH[Self-Hosted Runners]
        end
        
        subgraph "Data Subnets (Isolated)"
            RDS[Amazon RDS PostgreSQL]
        end
        
        ALB -->|Target Group: IP Mode| EKS
        NAT -->|Egress| Internet
    end

    CD -->|IAM Role Assumption| AWS