\x
select date_trunc('seconds',starttime) as time,filename as filename,line_number as line,
substring(colname,0,12) as column,  position as pos, raw_line as
 line_text,
raw_field_value as field_text,
err_reason as reason
from stl_load_errors sle join pg_user_info pui on (sle.userid = pui.usesysid)
where  query ilike :1
order by usename,time desc 
