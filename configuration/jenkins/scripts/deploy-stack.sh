#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Enter stack name, parameters file name, template file name to create, and enter region name. "
    exit 0
else
    STACK_NAME=$1
    PARAMETERS_FILE_NAME=$2
    TEMPLATE_NAME=$3
    REGION=$4
fi

if [[ "configuration/application/cloudformation/"$TEMPLATE_NAME != *.yml ]]; then
    echo "CloudFormation template $TEMPLATE_NAME does not exist. Make sure the extension is *.yml and not (*.yaml)"
    exit 0
fi

if [[ "configuration/application/cloudformation"$PARAMETERS_FILE_NAME != *.yml ]]; then
    echo "CloudFormation parameters $PARAMETERS_FILE_NAME does not exist"
    exit 0
fi


aws cloudformation deploy \
--stack-name $STACK_NAME \
--template-file file://configuration/application/cloudformation/$TEMPLATE_NAME \
--parameter-overrides file://configuration/application/cloudformation/$PARAMETERS_FILE_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--region $REGION
