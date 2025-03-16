#!/bin/bash

if [ "$1" = "vk" ]; then
    ./vk.sh "${@:2}"
elif [ "$1" = "prove" ]; then
    ./prove.sh "${@:2}"
else
    echo "Usage: $0 {vk|prove}"
    exit 1
fi
