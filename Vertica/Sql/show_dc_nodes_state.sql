select time
,case when node_name like '%0001' then node_state_name else null end as node0001
,case when node_name like '%0002' then node_state_name else null end as node0002
,case when node_name like '%0003' then node_state_name else null end as node0003
,case when node_name like '%0004' then node_state_name else null end as node0004
,case when node_name like '%0005' then node_state_name else null end as node0005
,case when node_name like '%0006' then node_state_name else null end as node0006
,case when node_name like '%0007' then node_state_name else null end as node0007
,case when node_name like '%0008' then node_state_name else null end as node0008
,case when node_name like '%0009' then node_state_name else null end as node0009
,case when node_name like '%0010' then node_state_name else null end as node0010
,case when node_name like '%0011' then node_state_name else null end as node0011
,case when node_name like '%0012' then node_state_name else null end as node0012
,case when node_name like '%0013' then node_state_name else null end as node0013
,case when node_name like '%0014' then node_state_name else null end as node0014
,case when node_name like '%0015' then node_state_name else null end as node0015
,case when node_name like '%0016' then node_state_name else null end as node0016
from (
select a.* from dc_node_state a
where node_name ilike  :1 and remote_node_name = node_name
  ) a
order by time::timestamp desc

