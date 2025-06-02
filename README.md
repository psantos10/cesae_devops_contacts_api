# README

Nome do Cluster: cesae-devops-2025-cluster-k8s
Região: eu-west-1

1º Passo: Criação do Cluster

eksctl create cluster --name cesae-devops-2025-cluster-k8s --version 1.32 --region eu-west-1 --nodegroup-name standard-workers --node-type t3.micro --nodes 2 --nodes-min 1 --nodes-max 3 --managed

2º Configurar o acesso para o kubectl

aws eks update-kubeconfig --region eu-west-1 --name cesae-devops-2025-cluster-k8s

3º Vericar a conexão com o cluster

kubectl get nodes

4º Instalação do Dashboard (Opcional):

```bash
# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```
