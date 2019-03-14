# BTCD Kube

BTCD Kube provides a simple way to deploy a full bitcoin node with BTCD into Kubernetes.           

[<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="100px">](https://kubernetes.io/docs/home "Kubernetes")  [<img src="https://avatars3.githubusercontent.com/u/10235229?s=200&v=4" width="100px">](https://github.com/btcsuite/btcd "BTCD")  [<img src="https://jenkins.io/images/logos/jenkins-x/jenkins-x-256.png" width="100px">](https://jenkins-x.io "Jenkins X")

This project is confirmed to work for simnet, testnet and mainnet on a minikube instance and a gke instance.

This project implements a full bitcoin node running in Kubernetes using https://github.com/btcsuite/btcd deployed by Jenkins X. 

The [Lightning Kube](https://github.com/kevinstl/lightning-kube) project gives a better high level view of how to install a fully functional Lightning Node. 


To install this project:
```
Requirments:

- Running Kubernetes cluster
- Jenkins X Executable installation
- Jenkins X instance running on Kubernetes cluster
```
*See [Lightning Kube](https://github.com/kevinstl/lightning-kube) for help with requirements.

1. Clone this project and the jx environment projects. 
```
git clone https://github.com/kevinstl/btcd-kube ~/Developer/projects/btcd-kube
git clone https://github.com/kevinstl/environment-jx-lightning-kube-simnet
git clone https://github.com/kevinstl/environment-jx-lightning-kube-testnet
git clone https://github.com/kevinstl/environment-jx-lightning-kube-mainnet
```
2. Change to project directory `cd ~/Developer/projects/btcd-kube`
3. Change the following variables in the [Jenkinsfile](./Jenkinsfile) to match your setup: ORG, APP_NAME, GITHUB_ADDRESS and ENV_REPO_PREFIX.
4. Change to scripts directory `cd ~/Developer/projects/btcd-kube/scripts`
5.  Add your persistent volume claim: `./create-pv.sh "" lightning-kube-mainnet -mainnet mainnet 275Gi gke` 
6.  Add your secrets: `./create-secrets.sh minikube lightning-kube mainnet YOUR_MINING_ADDRESS YOUR_RPC_USER YOUR_RPC_PASSWORD` 
7. Import this project and the jx environment projects into your Jenkins X instance. `jx import`

If the installation is successful you should see the btcd pod running from [kubernetes dashboard](http://minikube-easy:30000/#!/pod?namespace=lightning-kube).