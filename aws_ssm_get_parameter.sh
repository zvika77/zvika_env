#!/bin/sh


echo "==================="
echo "SSM GET PARAMETER"
echo "Param1: $1"
echo "==================="

aws ssm get-parameters --names $1 --with-decryption --output=table

aws ssm describe-parameters --filters Key=Name,Values=$1 --output=table
