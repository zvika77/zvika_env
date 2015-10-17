select Node_name,device,filesystem,(used_bytes/1024/1024/1024)::number(30,2) as usedGB,(free_bytes/1024/1024/1024)::number(30,2) as  freeGB,usage_percent from storage_usage 
where (Node_name ilike :1 or device ilike :1 or filesystem ilike :1 )
order by node_name,device,filesystem
