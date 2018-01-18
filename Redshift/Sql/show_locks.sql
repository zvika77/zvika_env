select trim(stp.name) as tname,date_trunc('seconds',last_commit) as last_commit
,date_trunc('seconds',last_update) as last_update,lock_owner as xid,lock_owner_pid as pid,
date_trunc('seconds',lock_owner_start_ts) as xid_start,date_trunc('seconds',lock_owner_end_ts) as xid_end_date
,lock_status
 from STV_LOCKS stl join (select distinct id,name from stv_tbl_perm)  stp on  (stl.table_id = stp.id)
