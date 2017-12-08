select data_collector_help();


SELECT * FROM v_monitor.data_collector
where table_name ilike :1 and node_name ilike '%001';

