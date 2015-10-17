#!/usr/bin/ksh



if [ $#  != 1 ] ; then
  echo "usage : sync.ksh  <host_name or ip>  "
  echo "example : sync.ksh  svpr-dbv05  "
  echo "example : sync.ksh  vertic@svpr-dbv05  "
  exit 1

fi

echo "Copying *.sql and *.ksh to $1 using scp ... "


scp *.sql $1:/lpbi/code/vertica/dba/zvika/Sql 

#scp *.ksh $1:/lpbi/code/vertica/dba/zvika/Sql
