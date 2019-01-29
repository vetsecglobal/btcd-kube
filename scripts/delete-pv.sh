#!/bin/bash

context=$1
namespace=$2
name=$3
networkSuffix=$4

echo "delete-pv.sh"

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

echo "debug1"
kubectl --namespace ${namespace} get pv lightning-kube-pvc${networkSuffix}
kubectl --namespace ${namespace} get pvc lightning-kube-pvc${networkSuffix}

cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} --namespace ${namespace} delete -f -

echo "debug2"
kubectl --namespace ${namespace} get pv lightning-kube-pvc${networkSuffix}
kubectl --namespace ${namespace} get pvc lightning-kube-pvc${networkSuffix}

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} --namespace ${namespace} delete -f -

echo "debug3"
kubectl --namespace ${namespace} get pv lightning-kube-pvc${networkSuffix}
kubectl --namespace ${namespace} get pvc lightning-kube-pvc${networkSuffix}

#./delete-pv.sh minikube lightning-kube