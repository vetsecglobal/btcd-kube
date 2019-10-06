#!/usr/bin/env bash

# exit from script if error was raised.
set -e

# error function is used within a bash function in order to send the error
# message directly to the stderr output and exit.
error() {
    echo "$1" > /dev/stderr
    exit 0
}

# return is used within bash function in order to return the value.
return() {
    echo "$1"
}

# set_default function gives the ability to move the setting of default
# env variable from docker file to the script thereby giving the ability to the
# user override it durin container start.
set_default() {
    # docker initialized env variables with blank string and we can't just
    # use -z flag as usually.
    BLANK_STRING='""'

    VARIABLE="$1"
    DEFAULT="$2"

    if [[ -z "$VARIABLE" || "$VARIABLE" == "$BLANK_STRING" ]]; then

        if [ -z "$DEFAULT" ]; then
            error "You should specify default variable"
        else
            VARIABLE="$DEFAULT"
        fi
    fi

   return "$VARIABLE"
}

# Set default variables if needed.
RPCUSER=$(set_default "$RPCUSER" "devuser_change")
RPCPASS=$(set_default "$RPCPASS" "devpass_change")
DEBUG=$(set_default "$DEBUG" "info")
NETWORK=$(set_default "$NETWORK" "simnet")

baseDir="/mnt/${NETWORK}"
baseBtcdDir=${baseDir}
baseRpcDir=${baseDir}/shared/rpc

networkArg=""
if [[ ${NETWORK} != "" && ${NETWORK} != "mainnet" ]]
then
    networkArg="--${NETWORK}"
fi

PARAMS=$(echo \
    "$networkArg" \
    "--debuglevel=$DEBUG" \
    "--rpcuser=$RPCUSER" \
    "--rpcpass=$RPCPASS" \
    "--datadir=${baseBtcdDir}/data" \
    "--logdir=${baseBtcdDir}/log" \
    "--rpccert=${baseRpcDir}/rpc.cert" \
    "--rpckey=${baseRpcDir}/rpc.key" \
    "--rpclisten=0.0.0.0" \
    "--txindex"
)

#    "--addpeer==185.36.237.188" \
#    "--blocksonly" \

#MINING_ADDRESS="empty"

echo "MINING_ADDRESS: |${MINING_ADDRESS}|"

echo "debug1"

# Set the mining flag only if address is non empty.
if [[ -n "$MINING_ADDRESS" && ${MINING_ADDRESS} != "empty" ]]; then
    echo "debug2"
    PARAMS="$PARAMS --miningaddr=$MINING_ADDRESS"
fi

echo "PARAMS: ${PARAMS}"

echo "debug3"

# Add user parameters to command.
PARAMS="$PARAMS $@"

btcdHostName="btcd-kube.lightning-kube-$NETWORK"
#btcdServiceIp=`ping ${btcdHostName} -c1 | head -1 | grep -Eo '[0-9.]{4,}'`

echo "btcdServiceIp: ${btcdServiceIp}"



echo "whoami: `whoami`"



ls -Ral /mnt
/bin/gencerts --host="*" --host="${btcdServiceIp}" --host="${btcdHostName}" --directory="${baseRpcDir}" --force
ls -Ral /mnt




# Print command and start bitcoin node.
echo "Command: btcd $PARAMS"
#exec btcd $PARAMS
timeout -t 7200 btcd $PARAMS

