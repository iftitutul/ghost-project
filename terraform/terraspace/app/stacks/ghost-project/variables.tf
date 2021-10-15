# This is where you put your variables declaration
variable "eks_cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = number
}


variable "eks_node_groups" {
  description = "Map of map of node groups to create. See node_groups module's documentation for more details"
  type        = any
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
}

variable "k8s_fargate_profile" {
  description = "Map of K8s Fargate profile to create"
  type        = any
}

variable "k8s_service_account_name" {}
variable "k8s_sa_oidc_iam_role_name" {}
variable "k8s_iam_policy_arn" {}
variable "k8s_fargate_pod_policy" {}