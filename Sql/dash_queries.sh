#!/bin/sh

rm -f dash_queries.${V_DB}_qvc.exp.out

echo "Running Explain..."
/opt/vertica/bin/vsql -U dbadmin -w in31ght -h ${V_DB}  -f dash_queries_qvc.exp -o dash_queries.${V_DB}_qvc.exp.out

#echo "Finished Explain..."

rm -f dash_queries.${V_DB}_qvc.sql.out
rm -f dash_queries.${V_DB}_qvc.sql.time

echo "Starting Serial Real run ..."

for i in {1..1}; do
	echo "Run: ${i} "
	cat dash_queries.env dash_queries_qvc.sql dash_queries.post | /opt/vertica/bin/vsql -U dbadmin -w in31ght -h ${V_DB} -a --echo-all >> dash_queries.${V_DB}_qvc.sql.out
#	cat dash_queries_qvc.sql dash_queries1.sql | /opt/vertica/bin/vsql -U dbadmin -w in31ght -h ${V_DB} -a --echo-all >> dash_queries_qvc.${V_DB}.sql.out
done

grep -E 'Time: |vertica-' dash_queries.${V_DB}_qvc.sql.out | grep -v 'dbadmin' >dash_queries.${V_DB}_qvc.sql.time

echo "Now Running diagnostic ... "

/opt/vertica/bin/diagnostics  -o /vertica/data/tmp

echo " Now Running scrutinize .. "

/opt/vertica/bin/scrutinize -U dbadmin -P 'in31ght' -m 'Case 00037182'  -o /vertica/data/tmp
#/opt/vertica/bin/scrutinize --by-minute -U username -P '<enter password here>' -m 'Case 00037066' -u 'ftp://convertro/C74nmRmi@customers.vertica.com/'

