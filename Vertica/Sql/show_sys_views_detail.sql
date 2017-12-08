\x
select query_string
from vs_system_views
where view_schema ilike :1
and (view_name ilike :2 or view_description ilike :2 )
;

