## ArgoCD can be installed either Helm or Kubectl


## Get ArgoCD Password

`# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

- https://cloudnative101.dev/lectures/continuous-deployment/activities/iks/

- https://gist.github.com/zironycho/86ab13e952281ab2d1383843b9cafadf

- https://blog.51cto.com/wzlinux/2940475

- https://dev.to/awscommunity-asean/ci-cd-with-argocd-on-aws-eks-cluster-3e09

- https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd
