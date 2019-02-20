# BTCD Kube

BTCD Kube provides a simple way to deploy a full bitcoin node with BTCD into Kubernetes.           

[<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="100px">](https://kubernetes.io/docs/home "Kubernetes")  [<img src="https://avatars3.githubusercontent.com/u/10235229?s=200&v=4" width="100px">](https://github.com/btcsuite/btcd "BTCD")  [<img src="https://jenkins.io/images/logos/jenkins-x/jenkins-x-256.png" width="100px">](https://jenkins-x.io "Jenkins X")

This project is confirmed to work for simnet and testnet on a minikube instance. **It has not been tested or hardened for security on mainnet.**

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

3. Clone this project. `git clone https://github.com/kevinstl/lightning-kube-btcd ~/Developer/projects/lightning-kube-btcd`
4. Change to project directory `cd ~/Developer/projects/lightning-kube-btcd`
5. Import this project into your Jenkins X instance. `jx import`

If the installation is successful you should see the btcd pod running from [kubernetes dashboard](http://minikube-easy:30000/#!/pod?namespace=lightning-kube).