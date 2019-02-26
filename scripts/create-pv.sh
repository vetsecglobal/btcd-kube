#!/bin/bash

#context=$1
namespace=$1
networkSuffix=$2
storage=$3

echo "create-pv.sh"

#echo "context: ${context}"
echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"
echo "storage: ${storage}"

#kubeContextArg=""
#if [[ ${context} != "" ]]
#then
#    kubeContextArg="--kube-context ${context}"
#fi

namespaceArg=""
if [[ ${namespace} != "" ]]
then
    namespaceArg="--namespace ${namespace}"
fi



#cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_STORAGE_X/${storage}/" | kubectl ${namespaceArg} create -f -

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_STORAGE_X/${storage}/"  | kubectl ${namespaceArg} create -f -


#ex: ./create-pv.sh lightning-kube-simnet -simnet 5Gi