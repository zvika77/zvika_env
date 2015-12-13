select substr(node_name,instr(node_name,'node')) as node_name,
"trx/stm",operator_name
,"rows produced",counter,path_id,
"Exceptions rows current size of temp files (bytes)",
"Exceptions rows cumulative size of temp files (bytes)",
"rejected data current size of temp files (bytes)",
"rejected data cumulative size of temp files (bytes)",
"rejected rows current size of temp files (bytes)",
"rejected rows cumulative size of temp files (bytes)"
from (
select node_name,transaction_id||' / '||statement_id as "trx/stm",
operator_name,count(distinct operator_id) as counter,path_id,
sum(decode(counter_name,'rows produced',counter_value,null)) as "rows produced",
(sum(decode(counter_name,'Exceptions rows current size of temp files (bytes)',counter_value,null)))::int as "Exceptions rows current size of temp files (bytes)",
(sum(decode(counter_name,'Exceptions rows cumulative size of temp files (bytes)',counter_value,null)))::int as "Exceptions rows cumulative size of temp files (bytes)",
sum(decode(counter_name,'rejected data current size of temp files (bytes)',counter_value,null)) as "rejected data current size of temp files (bytes)",
(sum(decode(counter_name,'rejected data cumulative size of temp files (bytes)',counter_value,null)))::number(30,2) as "rejected data cumulative size of temp files (bytes)",
(sum(decode(counter_name,'rejected rows current size of temp files (bytes)',counter_value,null)))::number(30,2) as "rejected rows current size of temp files (bytes)",
(sum(decode(counter_name,'rejected rows cumulative size of temp files (bytes)',counter_value,null)))::number(30,2) as "rejected rows cumulative size of temp files (bytes)"
from v_monitor.execution_engine_profiles
where transaction_id = :1
and statement_id = :2
--and counter_value/1024/1024 > 1
and node_name ilike :3
and counter_name in ('rows produced','Exceptions rows current size of temp files (bytes)','Exceptions rows cumulative size of temp files (bytes)'
'rejected data current size of temp files (bytes)','rejected data cumulative size of temp files (bytes)'
,'rejected rows current size of temp files (bytes)','rejected rows cumulative size of temp files (bytes)'
)
--and counter_name in ('execution time (us)','clock time (us)','estimated rows produced','rows produced','memory reserved (bytes)','memory allocated (bytes)')
group by node_name,transaction_id||' / '||statement_id,operator_name,path_id ) a
order by 1,6,4 desc;
