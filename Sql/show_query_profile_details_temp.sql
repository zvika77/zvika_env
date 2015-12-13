select substr(node_name,instr(node_name,'node')) as node_name,
"trx/stm",operator_name
,"rows produced",counter,path_id,
"current size of temp files (bytes)",
"cumulative size of temp files (bytes)",
"join inner current size of temp files (bytes)",
"join inner cumulative size of temp files (bytes)",
"cumulative size of raw temp data (bytes)",
"join inner cumulative size of raw temp data (bytes)"   
from (
select node_name,transaction_id||' / '||statement_id as "trx/stm",
operator_name,count(distinct operator_id) as counter,path_id,
sum(decode(counter_name,'rows produced',counter_value,null)) as "rows produced",
(sum(decode(counter_name,'current size of temp files (bytes)',counter_value,null)))::int as "current size of temp files (bytes)",
(sum(decode(counter_name,'cumulative size of temp files (bytes)',counter_value,null)))::int as "cumulative size of temp files (bytes)",
sum(decode(counter_name,'join inner current size of temp files (bytes)',counter_value,null)) as "join inner current size of temp files (bytes)",
(sum(decode(counter_name,'join inner cumulative size of temp files (bytes)',counter_value,null)))::number(30,2) as "join inner cumulative size of temp files (bytes)",
(sum(decode(counter_name,'cumulative size of raw temp data (bytes)',counter_value,null)))::number(30,2) as "cumulative size of raw temp data (bytes)",
(sum(decode(counter_name,'join inner cumulative size of raw temp data (bytes)',counter_value,null)))::number(30,2) as "join inner cumulative size of raw temp data (bytes)"  
from v_monitor.execution_engine_profiles
where transaction_id = :1
and statement_id = :2
and counter_value/1024/1024 > 1
and node_name ilike :3
and counter_name in ('rows produced','current size of temp files (bytes)','cumulative size of temp files (bytes)'
'join inner current size of temp files (bytes)','join inner cumulative size of temp files (bytes)'
,'cumulative size of raw temp data (bytes)','join inner cumulative size of raw temp data (bytes)'
)
--and counter_name in ('execution time (us)','clock time (us)','estimated rows produced','rows produced','memory reserved (bytes)','memory allocated (bytes)')
group by node_name,transaction_id||' / '||statement_id,operator_name,path_id ) a
order by 1,6,4 desc;
