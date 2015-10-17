\o /tmp/insert_query_profiles_hist.tmp

set timezone to 'UTC';

insert into dbadmin.query_profiles_hist 
(
query_start 
,user_name
,session_id
,node_name
,schema_name 
,table_name 
,transaction_id
,statement_id
,query 
,projections_used
,query_duration_us
,error_code 
,processed_row_count
,reserved_extra_memory
,identifier 
,query_search_path
,query_start_epoch
,query_type 
,is_executing
)
(select  
query_start::timestamptz
,user_name
,session_id
,node_name
,schema_name 
,table_name 
,transaction_id
,statement_id
,query 
,projections_used
,query_duration_us
,error_code 
,processed_row_count
,reserved_extra_memory
,identifier 
,query_search_path
,query_start_epoch
,query_type 
,is_executing
from query_profiles where query_start::timestamptz >= (select max(query_start) from dbadmin.query_profiles_hist) and is_executing = false);

commit;

\o
