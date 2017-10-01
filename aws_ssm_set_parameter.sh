#!/bin/sh


echo "===================="
echo "SSM SET PARAMETER"
echo "Param1: $1"
echo "Param2: $2"
echo "===================="


if [ "$#"  -eq 2 ]; then
	aws ssm put-parameter --name $1 --value $2 --type SecureString
else
	echo "===================="
	echo "aws_ssm_set_parameter"
	echo "Param1: Parameter Name"
	echo "Param2: Parameter Value"
	echo "===================="
fi
