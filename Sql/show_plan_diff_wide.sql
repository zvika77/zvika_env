select plan_diff  as diff,
path_id,path_line_index as idx,
case when plan_diff = '===>' then first_path_line else first_path_line end as :1,
case when plan_diff = '===>' then second_path_line else second_path_line end as :3
from (
select case when first.path_line != second.path_line then '===>' else '' end as plan_diff,
  first.path_id,first.path_line_index,
  first.path_line as 'first_path_line',second.path_line as 'second_path_line'
  from
(SELECT transaction_id ,
          statement_id ,
          path_id,
          path_line_index,
          regexp_replace(path_line,'Cost:\s\d+\w','Cost') AS path_line
   FROM sys_history.hist_v_monitor_query_plan_profiles
   where isutf8(path_line) = 't'
    and transaction_id =  :1 and statement_id = :2
    order by 3,4) first
    left  join
(SELECT transaction_id ,
          statement_id ,
          path_id,
          path_line_index,
          regexp_replace(path_line,'Cost:\s\d+\w','Cost') AS path_line
   FROM sys_history.hist_v_monitor_query_plan_profiles
   where isutf8(path_line) = 't'
    and transaction_id =  :3 and statement_id = :4
      order by 3,4 )  second
                              on (  first.path_id = second.path_id
                              AND  first.path_line_index = second.path_line_index
                              ) ) a
order by path_id,path_line_index;

