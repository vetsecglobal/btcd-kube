#!/bin/bash

context=$1
namespace=$2


kubectl create --context=${context} --namespace ${namespace} -f ./lightning-kube-pv.yaml
kubectl create --context=${context} --namespace ${namespace} -f ./lightning-kube-pvc.yaml

#./create-pv.sh minikube lightning-kube