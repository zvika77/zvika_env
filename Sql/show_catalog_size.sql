SELECT node_name, MAX (ts) AS ts, MAX(catalog_size_in_MB)
   AS catlog_size_in_MB
   FROM
   (SELECT node_name,
    TRUNC((dc_allocation_pool_statistics_by_second."time")::TIMESTAMP,
    'SS'::VARCHAR(2)) AS ts,
    SUM((dc_allocation_pool_statistics_by_second.total_memory_max_value
    - dc_allocation_pool_statistics_by_second.free_memory_min_value))/(1024*1024)
    AS catalog_size_in_MB from dc_allocation_pool_statistics_by_second GROUP BY 1,
    TRUNC((dc_allocation_pool_statistics_by_second."time")::TIMESTAMP,
    'SS'::VARCHAR(2))
    )
    subquery_1 GROUP BY 1 ORDER BY 1 LIMIT 50;

