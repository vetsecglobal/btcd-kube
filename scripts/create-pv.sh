#!/bin/bash

context=$1
namespace=$2
name=$3

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "name: ${name}"

kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

#kubectl create --context=${context} --namespace ${namespace} -f ./lightning-kube-pv.yaml
#kubectl create --context=${context} --namespace ${namespace} -f ./lightning-kube-pvc.yaml


cat ./lightning-kube-pv.yaml | sed "s/\X_NAME_X/${name}/" | kubectl ${kubeContextArg} --namespace ${namespace} create -f -
cat ./lightning-kube-pvc.yaml | sed "s/\X_NAME_X/${name}/" | kubectl ${kubeContextArg} --namespace ${namespace} create -f -

#./create-pv.sh minikube lightning-kube