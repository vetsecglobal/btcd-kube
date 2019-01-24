#!/bin/bash

context=$1
namespace=$2
name=$3


#kubectl create --context=${context} --namespace ${namespace} -f ./lightning-kube-pv.yaml
#kubectl create --context=${context} --namespace ${namespace} -f ./lightning-kube-pvc.yaml


cat ./lightning-kube-pv.yaml | sed "s/\X_NAME_X/${name}/" | kubectl --context=${context} --namespace ${namespace} create -f -
cat ./lightning-kube-pvc.yaml | sed "s/\X_NAME_X/${name}/" | kubectl --context=${context} --namespace ${namespace} create -f -

#./create-pv.sh minikube lightning-kube