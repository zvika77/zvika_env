select substr(node_name,instr(node_name,'node')) as node_name,
"trx/stm",operator_name
,"rows produced",counter,path_id,
"execution time(sec)","clock time (sec)",
"estimated rows produced",
"estimated rows produced"-"rows produced" as RowsDiff,
"memory reserved (MB)" ,
"memory allocated (MB)"
from (
select node_name,transaction_id||' / '||statement_id as "trx/stm",
operator_name,count(distinct operator_id) as counter,path_id,
(sum(decode(counter_name,'execution time (us)',counter_value,null))/1000000)::int as "execution time(sec)",
(sum(decode(counter_name,'clock time (us)',counter_value,null))/1000000)::int as "clock time (sec)",
sum(decode(counter_name,'estimated rows produced',counter_value,null)) as "estimated rows produced",
sum(decode(counter_name,'rows produced',counter_value,null)) as "rows produced",
(sum(decode(counter_name,'memory reserved (bytes)',counter_value/1024/1024,null)))::number(30,2) as "memory reserved (MB)",
(sum(decode(counter_name,'memory allocated (bytes)',counter_value/1024/1024,null)))::number(30,2) as "memory allocated (MB)"
from dc_execution_engine_profiles
where transaction_id = :1
and statement_id = :2
and counter_value/1000000 > 0
and node_name ilike :3
and counter_name in ('execution time (us)','clock time (us)','estimated rows produced','rows produced','memory reserved (bytes)','memory allocated (bytes)')
group by node_name,transaction_id||' / '||statement_id,operator_name,path_id ) a
order by 1,6,4 desc;
