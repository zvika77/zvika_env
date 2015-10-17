#!/bin/bash


############################################################################
#
#
#        conf file example 
#
#	:toDateMinusOne/to_timestamp\\('31\\/10\\/2013','dd\\/mm\\/yyyy'\\)
#	:accountId/'qa91270910'
#
#	Don't put blank lines anywhere on conf file
#
############################################################################

echo -n "Enter file_name [full path]: "
read source_path
echo -n "Enter traget dir[default is the /tmp]: "
read target_dir
echo -n "Enter replace configuration file [/home/zvikag/Vertica/Sql/replace.conf]: "
read conf_file



#init

#source_path=/tmp/replace.txt
#target_dir=/tmp
#conf_file=/home/zvikag/Vertica/Sql/replace.conf

if [ -z "$conf_file" ]
then
   conf_file="/home/zvikag/Vertica/Sql/replace.conf"
fi




dir_name=$(dirname ${source_path})

if [ -z "$target_dir" ]
then
   target_dir="/tmp"
fi

echo ${target_dir}




for source in ${source_path}
do

file_name=$( basename ${source})

echo "Backing up ${source} ..."
cp ${source} ${source}.orig

if [ $?  -ne 0 ]
 then
	echo "Backing up ${source} Failed !!!"
	exit 1
fi

while read line ; do
    echo "Replacing $line ..."
    sed   s/${line}/g ${source} > ${target_dir}/${file_name}.tmp
    if [ $?  -ne 0 ]
    then
        echo "Replace ${line}  Failed !!!"
        exit 1
    fi

    mv ${target_dir}/${file_name}.tmp ${source}
done < "${conf_file}"


mv ${source} ${target_dir}/${file_name}





echo "========================================"
echo "Original file: ${source}.orig  Conf file: ${conf_file} Target file: ${target_dir}/${file_name}"
echo "========================================"


done



echo "Please run replace_campaign.conf for those files"
echo "aovPerGroupSpecificCampaign.sql"
echo "campaignConversionsSpecificVsGT.sql"
echo "kpisSpecificCampaign.sql"
echo "kpisStatisticsSpecificCampaign.sql"

exit



#sed   "s/${param1}/g;s/${param2}/g;s/${param3}/g;s/${param4}/g;s/${param5}g;s/${param6}/g" ${source} > ${target_dir}/${file_name}.out


#sed   "s/:toDateMinusOne/to_timestamp\('31\/10\/2013','dd\/mm\/yyyy'\)/g;s/:fromDate/to_timestamp('01\/01\/2013','dd\/mm\/yyyy')/g;s/:toDate/to_timestamp\('01\/11\/2013','dd\/mm\/yyyy'\)/g;s/:campaignId/-1/g;s/:timezone/'GMT'/g;s/:accountId/'qa91270910'/g" ${source} > ${target_dir}/${file_name}.out

