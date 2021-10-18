## Cloud Migration (Ghost Blog) on AWS:

- [Architecture](https://github.com/iftitutul/ghost-project/blob/main/Ghost-Architecture-on-EKS.svg)

- Terraform: 
  - Using Terraspace to provistion the Infrastructure and manage the multiple AWS environments.
  - Create VPC with public, private subnet and create Nat Gateway on each availability zones.
  - EKS deployed on Private subnet of VPC.
  - AWS RDS deployed on Private subnet and allowed only MySQL Port (3306) within VPC.

- Helm:
  - Install AWS ALB Ingress controller to serve the frontend applications
  - Install Kubernetes external secret to manage sensitive data like credentials.

- Kubernetes: 
  - Ghost platform deployed on EKS cluster and backend service running via AWS RDS. then frontend serve via ALB ingress Controller and it's allowed only 443 port. 
  - Install metrics server on EKS and use horizontal pod autoscaler to scale the traffic.
  - Create kubernetes Secret using AWS Secret Manager to manage sensitive data.
  - Install ArgoCD tool on EKS cluster.
- Add ALB URL to the AWS Route53
  
## Future Scope:

- Implement CI/CD solution using Jenkins/Github Actions, ECR, ArgoCD etc.
- Implement WAF to protect the Frontend Application
- Disaster recovery for region failure
  - Deploy the same architecture on another region.
  - Implement AWS Global Accelerator provides static IP addresses that act as a fixed entry point to both ALB's and change GA point to AWS Route53
  - EKS cluster are running on different region and create VPC peering between them
  - Use AWS MySQL Multi A-Z region for automatic failover 
- Deploy Kubernetes manifest deployments using Helm with ArgoCD.
- Implement AWS Lambda functions to delete the posts.
- Implement Monitoring solution like promethues, Cloudwatch
- For Security, use Cloudtrail and AWS Guardduty and AWS inspector

