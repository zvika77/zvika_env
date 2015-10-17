SELECT * FROM sys_history.ec2_ip_to_names
where i_name ilike :1 or i_category ilike :1 or i_group ilike :1 or ip ilike :1
order by i_category,i_group,i_name,ip_type,last_updated desc ;
