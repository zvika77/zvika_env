select usename,query,slice,recordtime,((bytes_to_load/1024^2)||'/'||(bytes_to_load_compressed/1024^2))::int "MBto_load/comp"
,((bytes_loaded/1024^2)||'/'||(bytes_loaded_compressed/1024^2))::int "MBloaded/comp",lines
,num_files,num_files_complete,current_file,pct_complete
from stV_load_state sls join pg_user_info pui on (sls.userid = pui.usesysid)
where usename ilike :1
