select *,(dpo_mins+exp_dpo_mins+other_mins) as total_mins
,(dpo_rows+exp_dpo_rows+other_rows) as total_rows
 from (
select :1 as client,dates,
 sum(case when table_name  like 'next_rebuild_%_dash_performance_optimization' and instr(table_name,'exp') = 0 then mins else 0 end) as dpo_mins,
 sum(case when table_name  like 'next_rebuild_%_dash_performance_optimization' and instr(table_name,'exp') = 0 then rows else 0 end) as dpo_rows,
 sum(case when table_name  like 'next_rebuild_%_dash_performance_optimization' and instr(table_name,'exp') = 0 then num_loads else 0 end) as dpo_num_loads,
 --
 sum(case when table_name  like 'next_rebuild_%_exp_dash_performance_optimization' then mins else 0 end) as exp_dpo_mins,
 sum(case when table_name  like 'next_rebuild_%_exp_dash_performance_optimization' then rows else 0 end) as exp_dpo_rows,
 sum(case when table_name  like 'next_rebuild_%_exp_dash_performance_optimization' then num_loads else 0 end) as exp_dpo_num_loads,
--
 sum(case when table_name  not like 'next_rebuild_%_dash_performance_optimization' then mins else 0 end) as other_mins,
 sum(case when table_name  not like 'next_rebuild_%_dash_performance_optimization' then rows else 0 end) as other_rows,
 sum(case when table_name  not like 'next_rebuild_%_dash_performance_optimization' then num_loads else 0 end) as other_num_loads,
  count( distinct case when table_name  not like 'next_rebuild_%_dash_performance_optimization' then table_name else null end) as num_tables
  from (
select :1,date(query_start::TIMESTAMPTZ) dates,
  table_name,
  sum(query_duration_us/1000000/60)::int mins
  ,sum(processed_row_count) as rows
  ,count(*) as num_loads
from sys_history.hist_v_monitor_query_profiles
where user_name = 'dv2_etl'
and instr(table_name,:1) > 0
--and date(query_start::timestamptz)   = '2016-03-12'
group by :1,date(query_start::TIMESTAMPTZ),table_name ) a
group by :1,dates ) b
where dpo_rows > 0
order by 2 desc ;

