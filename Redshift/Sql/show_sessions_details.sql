select date_trunc('seconds',starttime) as starttime,date_trunc('seconds',endtime) as endtime,trim(pui.usename) as usename,(elapsed/1000)::int as sec,aborted,pid,xid,query,substring as text
from svl_qlog sql join pg_user_info pui on (sql.userid = pui.usesysid)
where (pid = :1  or xid = :1 or query = :1 )
order by starttime
