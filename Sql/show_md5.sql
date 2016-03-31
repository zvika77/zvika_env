select
user_name,
  md5(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(query,'''''',':##:apostrophe:##:'),'''.+?''',''''''),'\b[\d]+\b'),'\s*,\s*''''',''),':##:apostrophe:##:','''''')) as query_md5
,transaction_id,statement_id,
  (query_duration_us/1000000)::int as sec
  ,processed_row_count
  from query_profiles
where transaction_id::varchar = :1 and statement_id::varchar ilike :2
UNION
select
user_name,
  md5(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(query,'''''',':##:apostrophe:##:'),'''.+?''',''''''),'\b[\d]+\b'),'\s*,\s*''''',''),':##:apostrophe:##:','''''')) as query_md5
,transaction_id,statement_id,
  (query_duration_us/1000000)::int as sec
  ,processed_row_count
  from sys_history.hist_v_monitor_query_profiles
where transaction_id::varchar = :1 and statement_id::varchar ilike :2

