#!/bin/bash

AWS_PROFILE="ax-test"
AWS_REGION="us-east-1"
CLUSTER_NAME="test-cluster"

POLICY_ARN="arn:aws:iam::070866847466:policy/AWSLoadBalancerControllerIAMPolicy"

## Get VPC ID
VPC_ID=$(aws eks describe-cluster --name $CLUSTER_NAME --profile $AWS_PROFILE --region $AWS_REGION | jq '.cluster.resourcesVpcConfig.vpcId' | sed 's/"//g')

## Setup IAM role for service accounts

# echo 'Create an IAM policy called AWSLoadBalancerControllerIAMPolicy for the AWS Load Balancer Controller pod'
# POLICY_ARN=$(aws iam create-policy --profile $AWS_PROFILE --region $AWS_REGION\
#     --policy-name AWSLoadBalancerControllerIAMPolicy \
#     --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json \
#     | jq '.Policy.Arn' | sed 's/"//g')


echo 'Create an IAM role for the aws-load-balancer-controller and attach the role to the service account '
eksctl create iamserviceaccount \
  --profile=$AWS_PROFILE \
  --region=$AWS_REGION \
  --cluster=$CLUSTER_NAME \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=$POLICY_ARN \
  --override-existing-serviceaccounts \
  --approve

## Add Controller to Cluster

echo 'Add the EKS chart repo to helm'
helm repo add eks https://aws.github.io/eks-charts

echo 'Install the TargetGroupBinding CRDs if upgrading the chart via helm upgrade.'
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

echo 'Install the helm chart if using IAM roles for service accounts. NOTE you need to specify both of the chart values serviceAccount.create=false and serviceAccount.name=aws-load-balancer-controller'
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
    --set clusterName=$CLUSTER_NAME \
    --set serviceAccount.create=false \
    --set region=$AWS_REGION \
    --set vpcId=$VPC_ID \
    --set serviceAccount.name=aws-load-balancer-controller \
    -n kube-system

## Get Ouput
kubectl get deployment -n kube-system aws-load-balancer-controller