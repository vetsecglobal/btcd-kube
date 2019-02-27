#!/bin/bash

#context=$1
namespace=$1
networkSuffix=$2
storage=$3
deployEnv=$4

echo "create-pv.sh"

#echo "context: ${context}"
echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"
echo "storage: ${storage}"
echo "deployEnv: ${deployEnv}"

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

pvYaml="./lightning-kube-pvc.yaml"
if [[ ${deployEnv} == "gke" ]]
then
    pvYaml="./lightning-kube-pvc-gke.yaml"
fi

#cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} create -f -


if [[ ${deployEnv} != "gke" ]]
then
    cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_STORAGE_X/${storage}/" | kubectl ${namespaceArg} create -f -
fi

#cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_STORAGE_X/${storage}/"  | kubectl ${namespaceArg} create -f -
cat ${pvYaml} | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | sed "s/\X_STORAGE_X/${storage}/"  | kubectl ${namespaceArg} create -f -


#ex: ./create-pv.sh lightning-kube-simnet -simnet 5Gi
#ex: ./create-pv.sh lightning-kube-simnet -simnet 5Gi gke