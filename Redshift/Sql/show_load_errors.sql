select date_trunc('seconds',starttime) as time,trim(usename) as user_name ,query, substring(filename,22,25) as filename,line_number as line,
substring(colname,0,12) as column, type, position as pos, substring(raw_line,0,30) as
 line_text,
substring(raw_field_value,0,15) as field_text,
substring(err_reason,0,45) as reason
from stl_load_errors sle join pg_user_info pui on (sle.userid = pui.usesysid)
where  usename ilike :1
order by usename,time desc 
