#!/bin/bash

context=$1
namespace=$2

echo "context: ${context}"
echo "namespace: ${namespace}"

kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

#kubectl delete --context=${context} --namespace ${namespace} -f ./lightning-kube-pv.yaml
#kubectl delete --context=${context} --namespace ${namespace} -f ./lightning-kube-pvc.yaml

cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${name}/" | kubectl ${kubeContextArg} --namespace ${namespace} delete -f -
cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${name}/" | kubectl ${kubeContextArg} --namespace ${namespace} delete -f -

#./delete-pv.sh minikube lightning-kube