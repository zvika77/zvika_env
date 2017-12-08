select view_schema,view_name,view_description
from vs_system_views
where view_schema ilike :1
and (view_name ilike :2 or view_description ilike :2 )
order by view_schema,view_name
;

