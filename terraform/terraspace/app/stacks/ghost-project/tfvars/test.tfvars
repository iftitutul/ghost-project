eks_cluster_name = "<%= Terraspace.env %>-cluster"
eks_cluster_version = "1.21"
eks_node_groups = {
  first = {
    desired_capacity = "1"
    max_capacity = "3"
    min_capacity = "1"
    instance_types = ["t3.large"]
    update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
    }
  }
}

map_accounts= ["070866847466"]
map_users = [
    {
      userarn  = "arn:aws:iam::070866847466:user/iftikhar"
      username = "iftikhar"
      groups   = ["system:masters"]
    }
]

k8s_fargate_profile = {
    default = {
        name = "<%= Terraspace.env %>" 
        selectors = [
            {
                namespace = "<%= Terraspace.env %>"
            }
        ]
    }
}

k8s_service_account_name = "<%= Terraspace.env %>-eks-sa"
k8s_sa_oidc_iam_role_name = "<%= Terraspace.env %>-eks-oidc-role"
k8s_iam_policy_arn = [
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
  "arn:aws:iam::070866847466:policy/SecretsManagerReadPolicy"
]
k8s_fargate_pod_policy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"


### Security Group
sg_name = "ghost-RDS-SG"
sg_description = "Allow MySQL Port Withing VPC"

### RDS
rds_indentifier = "<%= Terraspace.env %>-ghost-mysql"
rds_name = "ghostdb"
rds_username = "<%= Terraspace.env %>"
rds_instance_type = "db.t3.micro"

### AWS Secret Manager
aws_secret_manager_name = "<%= Terraspace.env %>-eks/gh-db-secrets"