\x
select current_epoch,ahm_epoch,last_good_epoch
,refresh_epoch,designed_fault_tolerance,node_count,node_down_count
,current_fault_tolerance,catalog_revision_number,(wos_used_bytes/1024/1024)::number(30,2) wos_used_mb
,wos_row_count,(ros_used_bytes/1024/1024)::number(30,2) as ros_used_mb
,ros_row_count,(total_used_bytes/1024/1024/1024)::number(30,2) as total_used_gb
,total_row_count
 from system;
