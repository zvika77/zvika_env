select su.Node_name,node_address,device,filesystem,(used_bytes/1024/1024/1024)::number(30,2) as usedGB,(free_bytes/1024/1024/1024)::number(30,2) as  freeGB,usage_percent from storage_usage su left outer join nodes us on (su.node_name = us.node_name)
where (su.Node_name ilike :1 or device ilike :1 or filesystem ilike :1 )
order by su.node_name,device,filesystem
