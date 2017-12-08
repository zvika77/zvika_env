select 'TOTAL',rnum,plan_type,schema_name||'.'||table_name as object,count||' / '||KB as "count/KB"
,plan_type_MERGEOUT as plan_type1,schema_name_MERGEOUT||'.'||tname_MERGEOUT as object1,count_MERGEOUT||' / '||KB_MERGEOUT as "count/KB1"
FROM 
(select * from 
(select 
row_number () over ( order by count(*) desc) as rnum,
plan_type,schema_name,table_name,count(*),max(time) as time,sum(total_size_in_bytes)/1024::int as KB 
from (
select plan_type,schema_name,table_name,projection_name,max(time) as time ,max(total_size_in_bytes) as total_size_in_bytes 
from dc_tuple_mover_events a
where plan_type = 'Moveout'
--and time >= TIMESTAMPADD(HOUR,-1,sysdate)
group by plan_type,schema_name,table_name,projection_name,transaction_id
 ) b
group by plan_type,schema_name,table_name  ) move
where rnum <=5 )  moveout 
join
(select * from 
(select 
row_number () over ( order by count(*) desc) as rnum_MERGEOUT,
plan_type as plan_type_MERGEOUT,schema_name as schema_name_MERGEOUT,table_name as tname_MERGEOUT,count(*) as count_MERGEOUT ,max(time) as time_MERGEOUT,sum(total_size_in_bytes)/1024::int as KB_MERGEOUT 
from (
select plan_type,schema_name,table_name,projection_name,max(time) as time ,max(total_size_in_bytes) as total_size_in_bytes 
from dc_tuple_mover_events a
where plan_type = 'Mergeout'
--and time >= TIMESTAMPADD(HOUR,-1,sysdate)
group by plan_type,schema_name,table_name,projection_name,transaction_id
 ) b
group by plan_type,schema_name,table_name )  mrg
where rnum_MERGEOUT <=5 ) mergeout
on (moveout.rnum = mergeout.rnum_MERGEOUT)
order by count desc 
;



select 'LAST HOUR',to_char(TIMESTAMPADD(HOUR,-1,sysdate),'hh24:mi')||' - '||to_char(sysdate,'hh24:mi') as time,rnum,plan_type,schema_name||'.'||table_name as object,count||' / '||KB as "count/KB"
,plan_type_MERGEOUT as plan_type1,schema_name_MERGEOUT||'.'||tname_MERGEOUT as object1,count_MERGEOUT||' / '||KB_MERGEOUT as "count/KB1"
FROM 
(select * from 
(select 
row_number () over ( order by count(*) desc) as rnum,
plan_type,schema_name,table_name,count(*),max(time) as time,sum(total_size_in_bytes)/1024::int as KB 
from (
select plan_type,schema_name,table_name,projection_name,max(time) as time ,max(total_size_in_bytes) as total_size_in_bytes 
from dc_tuple_mover_events a
where plan_type = 'Moveout'
and time >= TIMESTAMPADD(HOUR,-1,sysdate)
group by plan_type,schema_name,table_name,projection_name,transaction_id
 ) b
group by plan_type,schema_name,table_name  ) move
where rnum <=5 )  moveout 
join
(select * from 
(select 
row_number () over ( order by count(*) desc) as rnum_MERGEOUT,
plan_type as plan_type_MERGEOUT,schema_name as schema_name_MERGEOUT,table_name as tname_MERGEOUT,count(*) as count_MERGEOUT ,max(time) as time_MERGEOUT,sum(total_size_in_bytes)/1024::int as KB_MERGEOUT 
from (
select plan_type,schema_name,table_name,projection_name,max(time) as time ,max(total_size_in_bytes) as total_size_in_bytes 
from dc_tuple_mover_events a
where plan_type = 'Mergeout'
and time >= TIMESTAMPADD(HOUR,-1,sysdate)
group by plan_type,schema_name,table_name,projection_name,transaction_id
 ) b
group by plan_type,schema_name,table_name )  mrg
where rnum_MERGEOUT <=5 ) mergeout
on (moveout.rnum = mergeout.rnum_MERGEOUT)
order by count desc 
;
