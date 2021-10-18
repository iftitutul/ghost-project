## DRONE Shuttles Ltd Cloud Migration (Ghost Blog): [Demo URL](https://test-gh.augmedix.com/)

- [Architecture](https://github.com/iftitutul/ghost-project/blob/main/Ghost-Architecture-on-EKS.svg)

- Terraform: Using Terraspace to provistion the Infrastructure like VPC,EKS, Security Group and AWS RDS (MySQL). So, it will be easily manage to multiple environments.

- Helm: On EKS, install ingress controller to serve the frontend applications and kubernetes external secret to manage the secrets.

- Kubernetes: 
  - EKS Cluster running on private subnet. so its more secure. Ghost platform deployed on EKS cluster and backend service running via AWS RDS. then frontend serve via ALB ingress Controller and it's allowed only 443 port. 
  - Install metrics server on EKS and use horizontal pod autoscaler to manage the traffic.
  - Create kubernetes Secret using AWS Secret Manager to manage sensitive data.
  - Install ArgoCD tool on EKS cluster.
  
## Future Scope:

- Implement CI/CD solution using Jenkins/Github Actions, ECR, ArgoCD etc.
- Implement WAF to protect the Frontend Application
- Disaster recovery for region failure
  - Deploy the same architecture on another region.
  - Implement AWS Global Accelerator provides static IP addresses that act as a fixed entry point to both ALB's
  - EKS cluster are running on different region and create VPC peering between them
  - Use AWS MySQL Multi A-Z region for automatic failover 
- Deploy Kubernetes manifest deployments using Helm with ArgoCD.
- Implement AWS Lambda functions to delete the posts.
- Implement Monitoring solution like promethues, Cloudwatch
- For Security, use Cloudtrail and AWS Guardduty and AWS inspector

