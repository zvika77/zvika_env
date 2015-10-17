select *,((accepted_row_count+rejected)/DurationSEC)::int as "rows/sec"
from (
select is_executing as run,session_id,schema_name,table_name,accepted_row_count 
,case when is_executing = true then timestampdiff(second,load_start::timestamp,sysdate::timestamp) else (load_duration_ms/1000)::int end  as DurationSEC
,to_char(load_start::timestamp,'hh24:mi:ss') as started
,rejected_row_count as rejected,(read_bytes/1024/1024)::INT as read_MB
,(input_file_size_bytes/1024/1024)::INT as file_size_MB,parse_complete_percent as "comp%"
,unsorted_row_count as unsorted_rows ,sorted_row_count as sorted_rows ,sort_complete_percent as "sort%"
from v_monitor.LOAD_STREAMS 
where is_executing = True
order by load_start::timestamptz desc,sort_complete_percent desc
) a
order by "sort%" 
