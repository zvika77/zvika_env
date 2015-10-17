select node_name,pool_name,
 (((memory_inuse_kb+general_memory_borrowed_kb)/MAX_MEMORY_SIZE_KB)*100)::int as "%mem_usage",
 (running_query_count/planned_concurrency*100)::int as "%query/plan",
 (running_query_count/max_concurrency*100)::int as "%query/max",
 (memory_size_kb/1024)::int as mem ,
(MAX_MEMORY_SIZE_KB/1024)::int as max_mem,
(memory_size_actual_kb/1024)::int as mem_act_alloc
,(memory_inuse_kb/1024)::int as mem_alloc_inuse
,(general_memory_borrowed_kb/1024)::int as mem_borrowed,
(queueing_threshold_kb/1024)::int as queue_threshold,running_query_count as query_count,planned_concurrency as planned_concu
,max_concurrency as max_concu
--,queue_timeout_in_seconds as queue_timeout_SEC
,(query_budget_kb/1024)::int as query_budget
FROM RESOURCE_POOL_STATUS
where pool_name ilike :1 or node_name ilike :1;

