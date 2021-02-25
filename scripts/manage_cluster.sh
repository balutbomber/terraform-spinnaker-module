#!/bin/bash

if eksctl get cluster $1;
then
    echo "$1 exists, nothing to do"
else
    echo "$1 does not exist, creating"
    eksctl create cluster --name=$1 --nodes=2 --region=$2 --zones $2a,$2b --write-kubeconfig=false
fi
