#!/bin/bash

echo 'Create namespace'
kubectl create namespace argocd

echo 'Install ArgoCD'
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo 'Change to NodePort'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'



