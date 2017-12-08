SELECT show_current_vertica_options();
SELECT add_vertica_options('OPT', 'ENABLE_WITH_CLAUSE_MATERIALIZATION');

with qpd as (
select user_name,
       query_start,
       label,
      query_fingerprint_md5,
       client_id,
       days,
       sec,
       processed_row_count,
       qpd_trx_id,qpd_stm_id,
       lead_trx_id,lead_stm_id,
       path_id,
        path_line_index,
        path_line
        from (
(SELECT user_name,
       query_start,
       label,
      query_fingerprint_md5,
       client_id,
       TIMESTAMPDIFF('day', from_date, to_date) AS days,
       (query_duration_us / 1000000) :: INT sec,
       processed_row_count,
       transaction_id as qpd_trx_id,
       statement_id as qpd_stm_id,
       lead(transaction_id) over (
                                      ORDER BY query_start) AS lead_trx_id,
       lead(statement_id) over (
                                    ORDER BY query_start) AS lead_stm_id
FROM sys_history.query_profiles_denormalized
WHERE query_fingerprint_md5 = :1
and (client_id ilike :2 or client_id is null)
  --and query_start > trunc(sysdate) -1 
  ) qpd
left join 
(SELECT transaction_id qpq_trx_id,
          statement_id qpq_stm_id,
          path_id,
          path_line_index,
          regexp_replace(path_line,'Cost:\s\d+\w','Cost') AS path_line
   FROM sys_history.hist_v_monitor_query_plan_profiles
   where isutf8(path_line) = 't') qpq
                              ON (qpd.qpd_trx_id = qpq.qpq_trx_id
                              AND qpd.qpd_stm_id = qpq.qpq_stm_id
                              )
))
-- start query
select /*+ label(md5_details) */ 
user_name,
       query_start,
       label,
      query_fingerprint_md5,
       client_id,
       days,
       sec,
       processed_row_count,
       qpd_trx_id,qpd_stm_id,
       max(plan_diff) as plan_diff
 from (
select  
case when qpd.path_line != qpq_lead.path_line then lead_trx_id::varchar else '' end as plan_diff,
user_name,
       query_start,
       label,
      query_fingerprint_md5,
       client_id,
       days,
       sec,
       processed_row_count,
       qpd_trx_id,qpd_stm_id,
       lead_trx_id,lead_stm_id,
       qpd.path_id,qpq_lead.path_id,
        qpd.path_line_index,qpq_lead.path_line_index,
        qpd.path_line,qpq_lead.path_line 
from qpd
LEFT JOIN
  (SELECT transaction_id qpq_trx_id,
          statement_id qpq_stm_id,
          path_id,
          path_line_index,
          regexp_replace(path_line,'Cost:\s\d+\w','Cost') AS path_line
   FROM sys_history.hist_v_monitor_query_plan_profiles
   where isutf8(path_line) = 't') qpq_lead ON (qpd.lead_trx_id = qpq_lead.qpq_trx_id
                              AND qpd.lead_stm_id = qpq_lead.qpq_stm_id
                              AND  qpd.path_id = qpq_lead.path_id
                              AND  qpd.path_line_index = qpq_lead.path_line_index) ) a
   group by user_name,
       query_start,
       label,
      query_fingerprint_md5,
       client_id,
       days,
       sec,
       processed_row_count,
       qpd_trx_id,qpd_stm_id 
  ORDER BY query_start DESC;



--SELECT clr_vertica_options('OPT', 'ENABLE_WITH_CLAUSE_MATERIALIZATION');
