#!/bin/bash

context=$1
namespace=$2
name=$3
networkSuffix=$4

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "name: ${name}"
echo "networkSuffix: ${networkSuffix}"

kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

#kubectl delete --context=${context} --namespace ${namespace} -f ./lightning-kube-pv.yaml
#kubectl delete --context=${context} --namespace ${namespace} -f ./lightning-kube-pvc.yaml

cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} --namespace ${namespace} delete -f -
cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} --namespace ${namespace} delete -f -

#./delete-pv.sh minikube lightning-kube