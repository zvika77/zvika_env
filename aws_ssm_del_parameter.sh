#!/bin/sh


echo "==================="
echo "SSM DELETE PARAMETER"
echo "Param1: $1"
echo "==================="

aws ssm delete-parameter --name $1
