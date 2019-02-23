#!/bin/bash

jx create env -n lightning-kube-simnet -l lightning-kube-simnet --namespace lightning-kube-simnet --promotion Manual
jx create env -n lightning-kube-testnet -l lightning-kube-testnet --namespace lightning-kube-testnet --promotion Manual
jx create env -n lightning-kube-mainnet -l lightning-kube-mainnet --namespace lightning-kube-mainnet --promotion Manual