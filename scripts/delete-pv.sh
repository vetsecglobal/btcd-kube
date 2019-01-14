#!/bin/bash

context=$1
namespace=$2


kubectl delete --context=${context} --namespace ${namespace} -f ./lightning-kube-pv.yaml
kubectl delete --context=${context} --namespace ${namespace} -f ./lightning-kube-pvc.yaml

#./delete-pv.sh minikube lightning-kube