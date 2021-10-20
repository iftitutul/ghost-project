# This is where you put your resource declaration

### Create VPC ###
module "vpc" {
  source = "./../../modules/vpc_3_9_0/"

  name = "test-vpc"

  cidr = "20.10.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  azs                 = ["<%= expansion(':REGION') %>a", "<%= expansion(':REGION') %>b", "<%= expansion(':REGION') %>c"]
  private_subnets     = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets      = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  database_subnets    = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

  create_database_subnet_route_table    = false
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

}

### Create EKS ###

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "ax-cluster" {
  source          = "./../../modules/eks_17_12_0"
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  node_groups = var.eks_node_groups

  fargate_profiles = var.k8s_fargate_profile

  write_kubeconfig = false
  map_users        = var.map_users
  map_accounts     = var.map_accounts
}

data "aws_eks_cluster" "cluster" {
  name = module.ax-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.ax-cluster.cluster_id
}

#
resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = var.k8s_fargate_pod_policy
  role       = module.ax-cluster.fargate_iam_role_name
}

# Create the OIDC
module "iam_assumable_role_with_oidc" {
  source                        = "./../../modules/iam_4_7_0/modules/iam-assumable-role-with-oidc"

  create_role                   = true
  role_name                     = var.k8s_sa_oidc_iam_role_name
  provider_url                  = replace(module.ax-cluster.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = var.k8s_iam_policy_arn
  #oidc_fully_qualified_subjects = ["system:serviceaccount:${"<%= Terraspace.env %>"}:${var.k8s_service_account_name}"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:*"]
}

### Security Group
module "security_group" {
  source  = "./../../modules/sg_4_4_0"

  name        = var.sg_name
  description = var.sg_description
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}

# Generate Random Passport
resource "random_password" "rds_password" {
  length           = 24
  special          = true
  upper            = true
  number           = true
  lower            = true
  override_special = "_%@"
}

### RDS
module "db" {
  source          = "./../../modules/rds_3_4_0"
  
  identifier = var.rds_indentifier

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = "mysql"
  engine_version       = "8.0.20"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = var.rds_instance_type

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  name     = var.rds_name
  username = var.rds_username
  password = random_password.rds_password.result
  port     = 3306

  multi_az               = false
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  //performance_insights_enabled          = true
  //performance_insights_retention_period = 7
  //create_monitoring_role                = true
  //monitoring_interval                   = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}

### AWS Secret Manager
resource "aws_secretsmanager_secret" "rds_credentials_secret" {
  name = var.aws_secret_manager_name

}

resource "aws_secretsmanager_secret_version" "rds_credentials_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_credentials_secret.id
  secret_string = <<EOF
{
  "username": "${module.db.db_instance_username}",
  "password": "${random_password.rds_password.result}",
  "engine": "mysql",
  "host": "${module.db.db_instance_address}",
  "port": "${module.db.db_instance_port}",
  "dbname": "${module.db.db_instance_name}",
  "dbInstanceIdentifier": "${module.db.db_instance_id}"
}
EOF
}