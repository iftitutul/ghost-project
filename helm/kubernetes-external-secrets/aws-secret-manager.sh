#!/bin/bash

AWS_REGION="us-east-1"
EKS_IAM_ROLE_ARN="arn:aws:iam::070866847466:role/test-eks-oidc-role"

## Add Helm repo
helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/

## To install the chart with AWS IAM Roles for Service Accounts
helm install external-secrets \
external-secrets/kubernetes-external-secrets \
--namespace kube-system \
--set env.AWS_REGION=$AWS_REGION \
--set securityContext."fsGroup"=65534 \
--set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=$EKS_IAM_ROLE_ARN