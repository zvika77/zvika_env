#!/bin/bash


SCRIPT_DIR=$SQL
SCRIPT_LOG=$LOG/create_user.txt
SCRIPT_LOG_MASTER=$LOG/create_user_master.txt
MAIL_ADDR="dbaoncall-lp@liveperson.com"
MAIL_FILE=$SCRIPT_DIR/mail_file.txt
#pass=`grep pass $SCRIPT_DIR/env | awk '{ print $2 }'`
STATUS=0
cd $SCRIPT_DIR




log_message()
{
   msg="$1"
   echo "$(date '+%d/%m/%Y %H:%M:%S'):: $msg" |  tee -a $SCRIPT_LOG
}

run_query()
{

log_message "CREATE USER: $query"
/opt/vertica/bin/vsql  -U $V_USER -w $V_PASS -h $V_DB -c "$query" 2>>$SCRIPT_LOG
STATUS=$?
check_error
}

check_error ()
{
 echo "Create user : " $STATUS
 if [ $STATUS -ne 0 ]
 then
        log_message "CREATE USER ERROR: $create_query FAILED"
	write_mail
	cat $SCRIPT_LOG >> $SCRIPT_LOG_MASTER
        exit 1
 fi
}

write_mail ()
{

if [ $STATUS -eq 0 ] 
then
   subject="Vertica [$V_DB] :Create User for $user "
   echo "Vertica user created successfully " > $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "Here is the connection info:" >>$MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "******************************" >> $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "USER: $user" >> $MAIL_FILE
   echo "PASS: $pass" >> $MAIL_FILE
   echo "DB HOST: $V_DB" >> $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "******************************" >> $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "do not forget to change the password periodically." >> $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "You can do it in SQuirreL by issuing the following command:" >> $MAIL_FILE
   echo "" >> $MAIL_FILE
   echo "alter user $user identified by 'NewPassword' replace 'OldPassword';" >> $MAIL_FILE

   /bin/mailx -s "$subject" $MAIL_ADDR < $MAIL_FILE > /dev/null

else
   echo "11111111111111111111111111111111111111111111111111111111111"
   subject="ERROR - Vertica [$V_DB] :Create User for $user "
   /bin/mailx -s "$subject" $MAIL_ADDR < $SCRIPT_LOG > /dev/null

fi
   STATUS=$?
   check_error
   log_message "CREATE USER: Mail Sent ...."

}
###################################################
#
###			MAIN			###
#
###################################################

echo ""> $SCRIPT_LOG

user=`echo $1 | tr '[:lower:]' '[:upper:]'`

log_message "********************************"
log_message "***   CREATE USER STARTED   ***"
log_message "********************************"


log_message "LOG file in $SCRIPT_LOG"
if [ $# -ne 1 ]
then
        log_message "CREATE USER ERROR : Number of parameters sent $# ($1)"
        echo "==========================================="
        echo ""
        echo "Usage: create_user.sh <username>   "
        echo ""
        echo "==========================================="
        exit 1
fi

pass=`date +%s | sha256sum | base64 | head -c 8 `
query="CREATE USER $user identified by '$pass' profile default";
run_query $query
query="GRANT USAGE ON SCHEMA PUBLIC to $user" ;
run_query $query
query="GRANT LP_GENERAL to $user" ;
run_query $query
query="alter user $user default role LP_GENERAL" ;
run_query $query

if [ $STATUS -ne 0 ]
then
   log_message "CREATE USER ERROR : CREATE USER FAILED"
   write_mail
   cat $SCRIPT_LOG >> $SCRIPT_LOG_MASTER
   exit 1
else
   log_message "CREATE USER FINISHED SUCCESSFULLY"
   write_mail
fi
cat $SCRIPT_LOG >> $SCRIPT_LOG_MASTER
exit 0

