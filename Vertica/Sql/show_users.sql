select  user_name,is_super_user,profile_name,
case when is_locked = true then lock_time else null end as lock_time
,resource_pool,all_roles,default_roles
,(MEMORY_CAP_KB) as memory_capMB
,(TEMP_SPACE_CAP_KB) as temp_space_capMB
,RUN_TIME_CAP 
,search_path
from v_catalog.users
where user_name ilike  :1

