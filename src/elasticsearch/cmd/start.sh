#!/bin/bash

# Load dependencies
source ~/.basher/lib/messagehandler.sh
source ~/.basher/lib/flaghandler.sh

# Check parameters
declare service_name options spaces is_compact tmp res_cod
service_name=elasticsearch
options=$*
spaces=$(hasFlag --no-spaces ${options}) && options=$(pruneFlag --no-spaces ${options})
[ ${spaces} -eq 1 ] && spaces=0 || spaces=1
[ -n "${options}" ] && noValidOptionsException "${service_name}" "${spaces}" "${spaces}"

# Check and start service if necessary
[ $(basher "${service_name}":status --output bool) -eq 1 ] && genericInfoMessage "${service_name} service is currently running" "${spaces}" "${spaces}" && exit 0
genericExecutionMessage "Trying to start ${service_name} service...\c" "${spaces}" 0
tmp=$(docker container start elasticsearch7.10 2>&1)
res_cod=$?
wrap "$(responseString ${res_cod})" 0 "${spaces}" 0 0 && exit ${res_cod}
