#!/bin/ksh 

echo =======================
echo user: $V_USER
echo db: $V_DB
echo =======================


psql -h $V_DB  -U $V_USER  -d $DATABASE -p $PORT -a  

