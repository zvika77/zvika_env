#!/bin/bash 
# usage: watch.sh  <sleep_duration> <your_command>

while :; 
  do 
  echo "$(date) interval $1"
  $2; 
  sleep $1; 
done
