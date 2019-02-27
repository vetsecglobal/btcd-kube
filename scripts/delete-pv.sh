#!/bin/bash

namespace=$1
networkSuffix=$2

echo "delete-pv.sh"

echo "namespace: ${namespace}"
echo "networkSuffix: ${networkSuffix}"

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

cat ./lightning-kube-pvc.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -

#cat ./lightning-kube-pv.yaml | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -

cat ${pvYaml} | sed "s/\X_NETWORK_SUFFIX_X/${networkSuffix}/" | kubectl ${kubeContextArg} ${namespaceArg} delete -f -


# ./delete-pv.sh lightning-kube-simnet -simnet