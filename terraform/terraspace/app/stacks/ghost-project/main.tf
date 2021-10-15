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
  #map_accounts     = var.map_accounts
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
  oidc_fully_qualified_subjects = ["system:serviceaccount:${"<%= Terraspace.env %>"}:${var.k8s_service_account_name}"]
}