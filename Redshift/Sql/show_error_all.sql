select 'stl_error' as "type",recordtime,usename,substring(querytxt,1,60)||'|'||aborted||'|'||ser.errcode||'|'||ser.context||'|'||error as info
from stl_error ser join pg_user_info pui on (ser.userid = pui.usesysid)
 left join stl_query squ on (ser.pid = squ.pid)
 where aborted  = 1
union all
select 'sshclient_error' as "type",recordtime,usename,substring(querytxt,1,60)||'|'||aborted||'|'||sse.ssh_username||'|'||sse.command||'|'||sse.error as info
from STL_SSHCLIENT_ERROR sse join pg_user_info pui on (sse.userid = pui.usesysid)
 left join stl_query squ on (sse.pid = squ.pid)
union all
select 'wlm_error' as "type"
,recordtime,usename,substring(querytxt,1,60)||'|'||aborted||'|'||swe.error_string as info
from STL_WLM_ERROR swe  join pg_user_info pui on (swe.userid = pui.usesysid)
 left join stl_query squ on (swe.pid = squ.pid)
union all
select 'load_error' as "type",starttime as recordtime,usename as usename ,query::varchar||'|'||substring(filename,22,25)||'|'||line_number
||'|'||substring(colname,0,12)||'|'|| type||'|'||position||'|'||substring(raw_line,0,30)||'|'||
substring(raw_field_value,0,15) ||'|'||substring(err_reason,0,45) as info
from stl_load_errors sle join pg_user_info pui on (sle.userid = pui.usesysid)
order by recordtime desc
