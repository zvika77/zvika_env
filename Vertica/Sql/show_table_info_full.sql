-- show tables.sql

select table_schema,table_name,owner_name,is_temp_table,is_system_table,partition_expression,create_time
 from v_catalog.tables  where (table_schema ilike :1 or owner_name ilike :1)
 and table_name ilike :2
order by table_schema,table_name;

-- show_projection.sql

select projection_schema,projection_name,owner_name,anchor_table_name,is_prejoin,create_type
,verified_fault_tolerance,is_up_to_date,has_statistics,is_segmented
from v_catalog.projections
where
(upper(projection_schema) ilike upper(:1) or upper(owner_name) ilike upper(:1) )
and (upper(projection_name) ilike upper(:2) or upper(anchor_table_name) ilike upper(:2));

-- show table_size.sql

SELECT p.projection_schema,p.anchor_table_name AS table_name,ps.projection_name, -- 460,140,454
     cast(SUM(ps.wos_row_count::number + ps.ros_row_count::number) as NUMBER(10,2)) AS row_count_sum,
     count(*) as count_nodes,
     cast (SUM(ps.wos_used_bytes::int + ps.ros_used_bytes::int)/1024/1024 AS NUMBER(10,2)) AS MB_count,
     cast (SUM(ps.wos_used_bytes::int + ps.ros_used_bytes::int)/(count(*))/1024/1024  AS NUMBER(10,2)) AS MB_per_node
   FROM  v_catalog.projections p
      JOIN v_monitor.projection_storage ps on p.projection_name = ps.projection_name and  p.projection_schema = ps.anchor_table_schema
   where p.projection_schema ilike :1
   and upper(p.anchor_table_name) ilike :2
   GROUP BY p.projection_schema,p.anchor_table_name ,ps.projection_name
   ORDER BY p.projection_schema,p.anchor_table_name ,ps.projection_name;

select node_name,anchor_table_schema,anchor_table_name,projection_name,
row_count,(used_bytes/1024/1024)::NUMBER(10,2) as used_MB,(wos_used_bytes/1024/1024)::NUMBER(10,2) wos_used_MB,(ros_used_bytes/1024/1024)::NUMBER(10,2) ros_used_MB,ros_count
from  v_monitor.projection_storage
where (anchor_table_name ilike :2 or projection_name ilike :2)
and anchor_table_schema ilike :1;


select projection_schema,projection_name,time_d,
-- mergeout
max(a.TM_MERGEOUT_row_count) as MERGEOUT_rows,
(max(a.TM_MERGEOUT_size_B)/1024)::number(10,2) as MERGEOUT_KB,
max(a.TM_MERGEOUT_count)::number(10,2) as MERGEOUT_COUNT,
-- moveout
max(a.TM_MOVEOUT_row_count) as MOVEOUT_rows,
(max(a.TM_MOVEOUT_size_B)/1024)::number(10,2) as MOVEOUT_KB,
max(a.TM_MOVEOUT_count) as MOVEOUT_COUNT
from (
select projection_schema,projection_name,to_char(time,'dd/mm/yy hh24') as time_d,trunc(time,'HH24') as time_e,
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
and  time > timestampadd(HOUR,:3,sysdate)
group by projection_schema,projection_name,time_d,time_e,plan_type
order by time_e desc ) a
group by projection_schema,projection_name,time_d,time_e
order by 1,2,3 


desc ;