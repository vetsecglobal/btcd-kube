#!/bin/bash

context=$1
namespace=$2
network=$3
deployPvc=$4

echo "context: ${context}"
echo "namespace: ${namespace}"
echo "network: ${network}"
echo "deployPvc: ${deployPvc}"

kubeContextArg=""
if [[ ${context} != "" ]]
then
    kubeContextArg="--kube-context ${context}"
fi

networkSuffix=""
if [[ ${network} != "" ]]
then
    networkSuffix="-${network}"
fi

helm ${kubeContextArg} del --purge lightning-kube-btcd${networkSuffix}

if [[ ${deployPvc} == "true" ]]
then
    cd ./scripts
    ./delete-pv.sh "${context}" "${namespace}"${networkSuffix} lightning-kube-btcd${networkSuffix} ${networkSuffix}
    ./create-pv.sh  "${context}" "${namespace}"${networkSuffix} lightning-kube-btcd${networkSuffix} ${networkSuffix}
    cd ..
fi

#if [ $? -eq 0 ]
#then
#  echo "Undeploy Success"
#else
#  echo "Undeploy Error" >&2
#fi

#./undeploy-helm.sh minikube
#./undeploy-helm.sh ""
