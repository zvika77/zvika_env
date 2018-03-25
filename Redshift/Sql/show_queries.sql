select trim(usename) user_name,trim(pid||'/'||xid) as "pid/xid",trim(label) as label,date_trunc('second',starttime) as start_time,datediff('second', starttime,endtime) as dur_sec,type,substring(text,1,100) as text
from SVL_STATEMENTTEXT svs join pg_user_info pui on (svs.userid = pui.usesysid)
where trim(usename) ilike :1
and sequence = 0
order by starttime desc ,xid,sequence
