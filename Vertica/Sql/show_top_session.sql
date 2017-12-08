select client_id,trx_stm as 'trx/stm',session_id,user_name,substr(current_statement,1,65) stm
,dur_min,client_hostname,mem_usMB as mem_acquiredMB,pool_name,thread_count,open_file_handle_count open_files
--,inqueue_sec
 from (
select   NVL(case when current_statement like 'COPY%' then REGEXP_SUBSTR(current_statement,'(/tmp/)(\w+).',1,1,'',2) else REGEXP_SUBSTR(current_statement,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,case when se.transaction_id is not null then se.transaction_id||'/'||se.statement_id else 'ZOMBIE' end as 'trx_stm',session_id,user_name,substr(current_statement,1,80) as current_statement,
timestampdiff('minute',statement_start,sysdate) as dur_min,client_hostname
,timestampdiff('second',queue_entry_timestamp,acquisition_timestamp) as inqueue_sec
,(vra.memory_inuse_kb/1024)::NUMBER(10,2) as mem_usMB,pool_name,thread_count,open_file_handle_count
,row_number () over (partition by session_id) as rnum 
from sessions se left outer join resource_acquisitions vra on (se.transaction_id = vra.transaction_id and se.statement_id = vra.statement_id)
where se.current_statement != ''  or se.statement_id is not null ) a
where rnum =1
order by dur_min desc 
