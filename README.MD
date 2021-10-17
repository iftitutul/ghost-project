# DRONE Shuttles Ltd Cloud Migration (Ghost Blog)

- Terraform: Using Terraspace to provistion the Infrastructure like VPC,EKS, Security Group and AWS RDS (MySQL). So, it will be easily manage to multiple environments.

- Helm: On EKS, install ingress controller to serve the frontend applications and kubernetes external secret to manage the secrets.

- Kubernetes: 
  - EKS Cluster running on private subnet. so its more secure. Ghost platform deployed on EKS cluster and backend service running via AWS RDS. then frontend serve via ALB ingress Controller and it's allowed only 443 port. 
  - Install metrics server on EKS and use horizontal pod autoscaler to manage the traffic.
  - Create kubernetes Secret using AWS Secret Manager to manage sensitive data.
  - Install ArgoCD tool on EKS cluster.
  
## Future Scope:
- Implement WAF to protect the Frontend Application
- For Disaster recovery, implement EKS cluster on different region and create VPC peering between them
- Deploy Kubernetes manifest deployments using Helm with ArgoCD.
- Implement AWS Lambda functions to delete the posts.
- Implement Monitoring solution like promethues, Cloudwatch
- For Security, use Cloudtrail and AWS Guardduty and AWS inspector

