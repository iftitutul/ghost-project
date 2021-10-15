# This is where you put your outputs declaration
# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

# output "elasticache_subnets" {
#   description = "List of IDs of elasticache subnets"
#   value       = module.vpc.elasticache_subnets
# }

# output "redshift_subnets" {
#   description = "List of IDs of redshift subnets"
#   value       = module.vpc.redshift_subnets
# }

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

### EKS

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.ax-cluster.cluster_endpoint
}

output "eks_fargate_iam_role_name" {
  description = "IAM role name for EKS Fargate pods"
  value       = module.ax-cluster.fargate_iam_role_name
}

output "fargate_profile_arns" {
  description = "Outputs from node groups"
  value       = module.ax-cluster.fargate_profile_arns
}