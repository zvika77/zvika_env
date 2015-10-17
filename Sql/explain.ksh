#!/bin/ksh

OUT_DIR=/tmp
DOT_DIR=/tmp
GRAPH_DIR=/var/www/html

script_full_path=$1
script=`echo $(basename $1)`
echo "script  => $script "
echo "script  => $script_full_path "
echo =======================
echo Param1 $param1
echo =======================



vsql -h $V_DB  -U $V_USER -w $V_PASS -a  --echo-all  -v 1="'$param1'" -v 2="'$param2'" -v 3="'$param3'" -v 4="'$param4'"  -f $script_full_path -o ${OUT_DIR}/${script}.out



# Get the line number that start the graph

start=`grep -n 'digraph' ${OUT_DIR}/${script}.out  | sed -E 's/^([0-9]+):.*$/\1/'  `
#	grep -n 'digraph' /tmp/1.tmp.out  | sed -E 's/^([0-9]+):.*$/\1/'
end=`cat ${OUT_DIR}/${script}.out | wc -l `

echo "start => $start "
echo "end => $end "

echo $start-3
sed -n '1,$(($start-3)) p' ${OUT_DIR}/${script}.out
echo "sed -n '1,$(($start-3)) p' ${OUT_DIR}/${script}.out"
exit
# create the graph file

sed -n '$start,$(($end-2)) p' ${OUT_DIR}/${script}.out > ${DOT_DIR}/${script}.out.dot
echo "sed -n '$start,$(($end-2)) p' ${OUT_DIR}/${script}.out > ${DOT_DIR}/${script}.out.dot"
#sed  "1,$(($start-1)) d"  < ${script}.out > ${DOT_DIR}/${script}.out.dot

#echo ${DOT_DIR}/${script}.out.dot

#process the grpah to png

echo "dot ${DOT_DIR}/${script}.out.dot -Tpng -o ${GRAPH_DIR}/${script}.out.png"
dot ${DOT_DIR}/${script}.out.dot -Tpng -o ${GRAPH_DIR}/${script}.out.png


echo ""
echo Graph file location:  /var/www/html/${script}.out.png
echo Graph avialable in Url:  http://tlvertica/${script}.out.png
~

