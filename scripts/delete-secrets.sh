#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2
network=$3

networkSuffix=""
if [[ ${network} != "" ]]
then
    networkSuffix="-${network}"
fi

namespaceArg=""
if [[ ${namespace} != "" ]]
then
    namespaceArg="--namespace ${namespace}${networkSuffix}"
fi

kubectl --context=${context} ${namespaceArg} delete -f ./secrets.yml


#./delete-secrets.sh minikube lightning-kube mainnet