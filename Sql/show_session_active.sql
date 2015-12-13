select client_id,trx_stm as 'trx/stm',session_id,user_name,current_statement
,dur,client_hostname
 from (
select   
NVL(case when current_statement like 'COPY public.next_rebuild_%' then REGEXP_SUBSTR(current_statement,'COPY public.next_rebuild_(\w*?)_',1,1,'',1)
           WHEN current_statement LIKE 'COPY%' THEN REGEXP_SUBSTR(current_statement, '(/tmp/)(\w+).', 1, 1,'', 2)
           else REGEXP_SUBSTR(current_statement,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
--NVL(case when current_statement like 'COPY%' then REGEXP_SUBSTR(current_statement,'(/tmp/)(\w+).',1,1,'',2) 
-- when regexp_like (current_statement , '\w*label\(monitor') then 'monitor' else REGEXP_SUBSTR(current_statement,'(client)\s*=\s*''(\w+)''',1,1,'',2) end,'') client_id
,case when statement_id is not null then transaction_id||'/'||statement_id else 'ZOMBIE' end as 'trx_stm',session_id,user_name,substr(current_statement,1,80) as current_statement,sysdate-statement_start::timestamp as dur,client_hostname
from sessions
where current_statement != ''   ) a
order by dur desc 
;
