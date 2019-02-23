#!/bin/bash

context=$1
namespace=$2
networkSuffix=$3
storage=$4

echo "create-pv.sh"

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"
echo "storage: ${storage}"

kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

namespaceArg=""
if [[ ${namespace} != "" ]]
then
    namespaceArg="--namespace ${namespace}"
fi

pvYaml="./lightning-kube-pv.yaml"
if [[ ${KUBE_ENV} != "local" ]]
then
    pvYaml="./lightning-kube-pv-gke.yaml"
fi


#cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_STORAGE_X/${storage}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -


#ex: ./create-pv.sh minikube