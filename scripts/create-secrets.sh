#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2
network=$3
miningAddress=`echo $4 | base64`

echo "encrypted miningAddress: ${miningAddress}"


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

cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/" | kubectl --context=${context} ${namespaceArg} create -f -

#cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/"


#./create-secrets.sh minikube lightning-kube rb6CBeh9F2z149iDP19xNV4Mgr8SQFbkFc
#./create-secrets.sh minikube lightning-kube mainnet empty