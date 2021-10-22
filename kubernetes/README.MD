## [AWS Sample Example](https://github.com/aws-quickstart/quickstart-eks-cdk-python/tree/main/demo-apps/ghost-cdk)

## Install kubectl using native package management

1. Update the apt package index and install packages needed to use the Kubernetes apt repository:

```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
```

2. Download the Google Cloud public signing key:

`sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg`

3. Add the Kubernetes apt repository:

```
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

4. Update apt package index with the new repository and install kubectl:

```
sudo apt-get update
sudo apt-get install -y kubectl
```

### kubectl config using AWS EKS

`aws eks --profile <profile-name> --region <region-name> update-kubeconfig --name <eks-cluster-name>`

## Install Helm

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

## Install eksctl

1.Download and extract the latest release of eksctl with the following command. 

`curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp`

2. Move the extracted binary to /usr/local/bin.

`sudo mv /tmp/eksctl /usr/local/bin`

3. Test that your installation was successful with the following command.

`eksctl version`

## Install jq on Ubuntu

```
sudo apt update
sudo apt install jq -y
```

## More Notes
- [Installing the Kubernetes Metrics Server](https://github.com/awsdocs/amazon-eks-user-guide/blob/master/doc_source/metrics-server.md)

- [AWS EKS user guide](https://github.com/awsdocs/amazon-eks-user-guide/tree/master/doc_source)
