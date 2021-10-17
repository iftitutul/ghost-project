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

### Security Group
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.security_group.security_group_name
}


### RDS
output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db.db_instance_hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.db_instance_id
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db.db_instance_resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.db.db_instance_status
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db.db_instance_username
  sensitive   = true
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.db.db_instance_password
  sensitive   = true
}

