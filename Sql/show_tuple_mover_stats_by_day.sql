\o /tmp/show_tuple_mover_stats.log
select time_d,
-- deleted vector moveout
max(a.TM_DVWOS_MOVEOUT_row_count) as DVWOS_MOVEOUT_row,
(max(a.TM_DVWOS_MOVEOUT_size_B)/1024/1024)::number(10,2) as DVWOS_MOVEOUT_MB,
max(a.TM_DVWOS_MOVEOUT_count) as DVWOS_MOVEOUT_COUNT,
-- replay delete move
max(a.TM_REDELETE_MOVE_row_count) as REDELETE_MOVE_rows,
(max(a.TM_REDELETE_MOVE_size_B)/1024/1024)::NUMBER(10,2) as REDELETE_MOVE_MB,
max(a.TM_REDELETE_MOVE_count)::int as REDELETE_MOVE_COUNT,
-- replay delete merge
max(a.TM_REDELETE_MERGE_row_count) as REDELETE_MERGE_rows,
(max(a.TM_REDELETE_MERGE_size_B)/1024/1024)::NUMBER(10,2) as REDELETE_MERGE_MB,
max(a.TM_REDELETE_MERGE_count)::int as REDELETE_MERGE_COUNT
from (
select to_char(time,'dd/mm/yy') as time_d,trunc(time) as time_e,
-- mergeout
decode(plan_type,'TM_MERGEOUT',sum(row_count),0) as TM_MERGEOUT_row_count ,
decode(plan_type,'TM_MERGEOUT',sum(size_in_bytes),0) as TM_MERGEOUT_size_B,
decode(plan_type,'TM_MERGEOUT',count(*),0) as TM_MERGEOUT_count,
-- moveout
decode(plan_type,'TM_MOVEOUT',sum(row_count),0) as TM_MOVEOUT_row_count ,
decode(plan_type,'TM_MOVEOUT',sum(size_in_bytes),0) as TM_MOVEOUT_size_B ,
decode(plan_type,'TM_MOVEOUT',count(*),0) as TM_MOVEOUT_count ,
-- direct load
decode(plan_type,'TM_DIRECTLOAD',sum(row_count),0) as TM_DIRECTLOAD_row_count ,
decode(plan_type,'TM_DIRECTLOAD',sum(size_in_bytes),0) as TM_DIRECTLOAD_size_B ,
decode(plan_type,'TM_DIRECTLOAD',count(*),0) as TM_DIRECTLOAD_count ,
--deleted vector moveout
decode(plan_type,'TM_DVWOS_MOVEOUT',sum(row_count),0) as TM_DVWOS_MOVEOUT_row_count ,
decode(plan_type,'TM_DVWOS_MOVEOUT',sum(size_in_bytes),0) as TM_DVWOS_MOVEOUT_size_B,
decode(plan_type,'TM_DVWOS_MOVEOUT',count(*),0) as TM_DVWOS_MOVEOUT_count,
-- replay deleyte move 
decode(plan_type,'TM_REDELETE_MOVE',sum(row_count),0) as TM_REDELETE_MOVE_row_count ,
decode(plan_type,'TM_REDELETE_MOVE',sum(size_in_bytes),0) as TM_REDELETE_MOVE_size_B ,
decode(plan_type,'TM_REDELETE_MOVE',count(*),0) as TM_REDELETE_MOVE_count ,
-- replay delete merge
decode(plan_type,'TM_REDELETE_MERGE',sum(row_count),0) as TM_REDELETE_MERGE_row_count ,
decode(plan_type,'TM_REDELETE_MERGE',sum(size_in_bytes),0) as TM_REDELETE_MERGE_size_B,
decode(plan_type,'TM_REDELETE_MERGE',count(*),0) as TM_REDELETE_MERGE_count
from dc_roses_created
where projection_schema ilike :1
and (projection_name ilike :2 or node_name ilike :2 )
group by time_d,time_e,plan_type 
order by time_e desc ) a 
group by time_d,time_e
order by 1 desc ;

select time_d,
-- direct load
max(a.TM_DIRECTLOAD_row_count) as DIRECTLOAD_rows,
(max(a.TM_DIRECTLOAD_size_B)/1024/1024)::NUMBER(10,2) as TIRECTLOAD_MB,
max(a.TM_DIRECTLOAD_count) as DIRECTLOAD_COUNT
from (
select to_char(time,'dd/mm/yy') as time_d,trunc(time) as time_e,
-- mergeout
decode(plan_type,'TM_MERGEOUT',sum(row_count),0) as TM_MERGEOUT_row_count ,
decode(plan_type,'TM_MERGEOUT',sum(size_in_bytes),0) as TM_MERGEOUT_size_B,
decode(plan_type,'TM_MERGEOUT',count(*),0) as TM_MERGEOUT_count,
-- moveout
decode(plan_type,'TM_MOVEOUT',sum(row_count),0) as TM_MOVEOUT_row_count ,
decode(plan_type,'TM_MOVEOUT',sum(size_in_bytes),0) as TM_MOVEOUT_size_B ,
decode(plan_type,'TM_MOVEOUT',count(*),0) as TM_MOVEOUT_count ,
-- direct load
decode(plan_type,'TM_DIRECTLOAD',sum(row_count),0) as TM_DIRECTLOAD_row_count ,
decode(plan_type,'TM_DIRECTLOAD',sum(size_in_bytes),0) as TM_DIRECTLOAD_size_B ,
decode(plan_type,'TM_DIRECTLOAD',count(*),0) as TM_DIRECTLOAD_count ,
--deleted vector moveout
decode(plan_type,'TM_DVWOS_MOVEOUT',sum(row_count),0) as TM_DVWOS_MOVEOUT_row_count ,
decode(plan_type,'TM_DVWOS_MOVEOUT',sum(size_in_bytes),0) as TM_DVWOS_MOVEOUT_size_B,
decode(plan_type,'TM_DVWOS_MOVEOUT',count(*),0) as TM_DVWOS_MOVEOUT_count,
-- replay deleyte move
decode(plan_type,'TM_REDELETE_MOVE',sum(row_count),0) as TM_REDELETE_MOVE_row_count ,
decode(plan_type,'TM_REDELETE_MOVE',sum(size_in_bytes),0) as TM_REDELETE_MOVE_size_B ,
decode(plan_type,'TM_REDELETE_MOVE',count(*),0) as TM_REDELETE_MOVE_count ,
-- replay delete merge
decode(plan_type,'TM_REDELETE_MERGE',sum(row_count),0) as TM_REDELETE_MERGE_row_count ,
decode(plan_type,'TM_REDELETE_MERGE',sum(size_in_bytes),0) as TM_REDELETE_MERGE_size_B,
decode(plan_type,'TM_REDELETE_MERGE',count(*),0) as TM_REDELETE_MERGE_count
from dc_roses_created
where projection_schema ilike :1
and (projection_name ilike :2 or node_name ilike :2 )
group by time_d,time_e,plan_type
order by time_e desc ) a
group by time_d,time_e
order by 1 desc ;


select time_d,
-- mergeout
max(a.TM_MERGEOUT_row_count) as MERGEOUT_rows,
(max(a.TM_MERGEOUT_size_B)/1024/1024)::NUMBER(10,2) as MERGEOUT_MB,
max(a.TM_MERGEOUT_count)::int as MERGEOUT_COUNT,
-- moveout
max(a.TM_MOVEOUT_row_count) as MOVEOUT_rows,
(max(a.TM_MOVEOUT_size_B)/1024/1024)::NUMBER(10,2) as MOVEOUT_MB,
max(a.TM_MOVEOUT_count) as MOVEOUT_COUNT
from (
select to_char(time,'dd/mm/yy') as time_d,trunc(time) as time_e,
-- mergeout
decode(plan_type,'TM_MERGEOUT',sum(row_count),0) as TM_MERGEOUT_row_count ,
decode(plan_type,'TM_MERGEOUT',sum(size_in_bytes),0) as TM_MERGEOUT_size_B,
decode(plan_type,'TM_MERGEOUT',count(*),0) as TM_MERGEOUT_count,
-- moveout
decode(plan_type,'TM_MOVEOUT',sum(row_count),0) as TM_MOVEOUT_row_count ,
decode(plan_type,'TM_MOVEOUT',sum(size_in_bytes),0) as TM_MOVEOUT_size_B ,
decode(plan_type,'TM_MOVEOUT',count(*),0) as TM_MOVEOUT_count ,
-- direct load
decode(plan_type,'TM_DIRECTLOAD',sum(row_count),0) as TM_DIRECTLOAD_row_count ,
decode(plan_type,'TM_DIRECTLOAD',sum(size_in_bytes),0) as TM_DIRECTLOAD_size_B ,
decode(plan_type,'TM_DIRECTLOAD',count(*),0) as TM_DIRECTLOAD_count ,
--deleted vector moveout
decode(plan_type,'TM_DVWOS_MOVEOUT',sum(row_count),0) as TM_DVWOS_MOVEOUT_row_count ,
decode(plan_type,'TM_DVWOS_MOVEOUT',sum(size_in_bytes),0) as TM_DVWOS_MOVEOUT_size_B,
decode(plan_type,'TM_DVWOS_MOVEOUT',count(*),0) as TM_DVWOS_MOVEOUT_count,
-- replay deleyte move
decode(plan_type,'TM_REDELETE_MOVE',sum(row_count),0) as TM_REDELETE_MOVE_row_count ,
decode(plan_type,'TM_REDELETE_MOVE',sum(size_in_bytes),0) as TM_REDELETE_MOVE_size_B ,
decode(plan_type,'TM_REDELETE_MOVE',count(*),0) as TM_REDELETE_MOVE_count ,
-- replay delete merge
decode(plan_type,'TM_REDELETE_MERGE',sum(row_count),0) as TM_REDELETE_MERGE_row_count ,
decode(plan_type,'TM_REDELETE_MERGE',sum(size_in_bytes),0) as TM_REDELETE_MERGE_size_B,
decode(plan_type,'TM_REDELETE_MERGE',count(*),0) as TM_REDELETE_MERGE_count
from dc_roses_created
where projection_schema ilike :1
and (projection_name ilike :2 or node_name ilike :2 )
group by time_d,time_e,plan_type
order by time_e desc ) a
group by time_d,time_e
order by 1 desc ;

\o
\!view /tmp/show_tuple_mover_stats.log
