#!/bin/bash

#MINING_ADDRESS

context=$1
namespace=$2

miningAddress=`echo $3 | base64`

echo "encrypted miningAddress: ${miningAddress}"

cat ./secrets.yml | sed "s/\X_MINING_ADDRESS_X/$miningAddress/" | kubectl --context=${context} --namespace ${namespace} create -f -


#./create-secrets.sh minikube lightning-kube 1JFdJnByx6a88M9x6tugcv9Zm8JRMb8aEC