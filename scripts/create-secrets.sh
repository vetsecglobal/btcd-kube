#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2

miningAddress=`echo $3 | base64`

echo "encrypted miningAddress: ${miningAddress}"

cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/" | kubectl --context=${context} --namespace ${namespace} create -f -

#cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/${miningAddress}/"


#./create-secrets.sh minikube lightning-kube rh3dEKMc1E9bLUdHqH8XRh5xps6R9cwXra