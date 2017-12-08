#!/bin/ksh




echo USER: $V_USER
echo DB  : $V_DB

vsql -h $V_DB  -U $V_USER -w $V_PASS -a  
