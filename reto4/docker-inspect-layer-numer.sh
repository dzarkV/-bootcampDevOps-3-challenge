#!/bin/bash 

FILTER='first | .RootFS | .Layers | length'

echo $(docker inspect $1 | jq -r "${FILTER[@]}")
