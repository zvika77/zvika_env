select end_time,
 sum(case when node_name = 'v_insight_node0001' then  average_memory_usage_percent else 0 end) as "%mem_01"
,sum(case when node_name = 'v_insight_node0002' then  average_memory_usage_percent else 0 end) as "%mem_02"
,sum(case when node_name = 'v_insight_node0003' then  average_memory_usage_percent else 0 end) as "%mem_03"
,sum(case when node_name = 'v_insight_node0004' then  average_memory_usage_percent else 0 end) as "%mem_04"
,sum(case when node_name = 'v_insight_node0005' then  average_memory_usage_percent else 0 end) as "%mem_05"
,sum(case when node_name = 'v_insight_node0006' then  average_memory_usage_percent else 0 end) as "%mem_06"
,sum(case when node_name = 'v_insight_node0007' then  average_memory_usage_percent else 0 end) as "%mem_07"
,sum(case when node_name = 'v_insight_node0008' then  average_memory_usage_percent else 0 end) as "%mem_08"
,sum(case when node_name = 'v_insight_node0009' then  average_memory_usage_percent else 0 end) as "%mem_09"
,sum(case when node_name = 'v_insight_node0010' then  average_memory_usage_percent else 0 end) as "%mem_10"
,sum(case when node_name = 'v_insight_node0011' then  average_memory_usage_percent else 0 end) as "%mem_11"
,sum(case when node_name = 'v_insight_node0012' then  average_memory_usage_percent else 0 end) as "%mem_12"
,sum(case when node_name = 'v_insight_node0013' then  average_memory_usage_percent else 0 end) as "%mem_13"
,sum(case when node_name = 'v_insight_node0014' then  average_memory_usage_percent else 0 end) as "%mem_14"
from system_resource_usage
  group by end_time
order by end_time desc;
