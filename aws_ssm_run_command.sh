#!/bin/sh  -e


tag_key=$1
tag_value=$2
command=$3

echo "===================="
echo "tag_key: $tag_key"
echo "tag_value: $tag_value"
echo "command: $command"
echo "===================="
cmd=$(echo $command | awk '{print $1}')
#arg1=$(echo $command | awk '{print $2}')
#arg2=$(echo $command | awk '{print $3}')
if [ ! -z $arg1 ]; then
	arg1=\,\"${arg1}\"
	full_arg=${arg1} 
fi

if [ ! -z $arg2 ]; then
	arg2=\,\"${arg2}\"
	full_arg="${arg1}${arg2}"
fi
echo "full arg: $full_arg"
full_cmd=\"${cmd}\"${full_arg}
echo "full cmd : $full_cmd"
if [ "$#"  -eq 3 ]; then
	echo "command=${command}"
	cmd=${command}
	echo "cmd=${cmd}"
	cmd_id=$(aws ssm send-command --document-name "AWS-RunShellScript"  --targets \{\"Key\":\"tag:${tag_key}\",\"Values\":["\"${tag_value}\""]\} --parameters \{\"commands\":["\"${command}\""]\} --output text --query "Command.CommandId") 
	echo "CommandID: ${cmd_id}"
	status=\"InProgress\"
	while [ ${status} == \"InProgress\" ] 
	do
		status=$(aws ssm list-commands  --command-id ${cmd_id} --query Commands[0].Status)
		echo -n  "${status} ..."
		sleep 5
	done
	echo "  "
	if [ ${status} == \"Success\" ]; then
		aws ssm list-command-invocations --command-id ${cmd_id} --details --query 'CommandInvocations[*].{InstanceName:InstanceName,output:CommandPlugins[*].Output}' --output text
	else
		echo "***** COMMAND STATUS: ${status} ******"
		aws ssm list-commands  --command-id ${cmd_id}
	fi

else
	echo "===================="
	echo "PARAMTER ERROR"
	echo "tag_key: $tag_key"
	echo "tag_value: $tag_value"
	echo "command: $command"
	echo "===================="
fi
