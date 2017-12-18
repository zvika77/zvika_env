select trim(usename) user_name,xid,trim(label) as label,date_trunc('second',starttime) as start_time,datediff('minute', starttime,endtime) as dur_min,type,sequence,text
from SVL_STATEMENTTEXT svs join pg_user_info pui on (svs.userid = pui.usesysid)
where usename ilike :1
order by starttime desc ,xid,sequence
