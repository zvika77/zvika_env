select date
,max(case when node_name like '%0001' then node_state_name else null end) as node0001
,max(case when node_name like '%0002' then node_state_name else null end) as node0002
,max(case when node_name like '%0003' then node_state_name else null end) as node0003
,max(case when node_name like '%0004' then node_state_name else null end) as node0004
,max(case when node_name like '%0005' then node_state_name else null end) as node0005
,max(case when node_name like '%0006' then node_state_name else null end) as node0006
,max(case when node_name like '%0007' then node_state_name else null end) as node0007
,max(case when node_name like '%0008' then node_state_name else null end) as node0008
,max(case when node_name like '%0009' then node_state_name else null end) as node0009
,max(case when node_name like '%0010' then node_state_name else null end) as node0010
,max(case when node_name like '%0011' then node_state_name else null end) as node0011
,max(case when node_name like '%0012' then node_state_name else null end) as node0012
--,max(case when node_name like '%0013' then node_state_name else null end) as node0013
--,max(case when node_name like '%0014' then node_state_name else null end) as node0014
--,max(case when node_name like '%0015' then node_state_name else null end) as node0015
--,max(case when node_name like '%0016' then node_state_name else null end) as node0016
--,max(case when node_name like '%0017' then node_state_name else null end) as node0017
--,max(case when node_name like '%0018' then node_state_name else null end) as node0018
--,max(case when node_name like '%0019' then node_state_name else null end) as node0019
--,max(case when node_name like '%0020' then node_state_name else null end) as node0020
from (
select to_char(time,'dd/mm/yy hh24:mi:ss') as date,a.* from dc_node_state a
where node_name ilike  :1
order by time desc  ) a
group by date
ORDER BY DATE DESC 
