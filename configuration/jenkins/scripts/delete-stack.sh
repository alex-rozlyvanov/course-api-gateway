#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Enter stack name to delete & region name."
    exit 0
else
    STACK_NAME=$1
    REGION=$2
fi

aws cloudformation delete-stack \
--stack-name $STACK_NAME \
--region $REGION

aws cloudformation wait stack-delete-complete \
--stack-name $STACK_NAME \
--region $REGION
