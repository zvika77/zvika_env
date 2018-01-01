select pna.nspname,relname as obj_name,relnamespace,pui.usename,
  case   when pcl.relkind = 'r'  then 'table '
        when pcl.relkind = 'i' then 'index'
        when pcl.relkind = 'S' then 'sequence'
        when pcl.relkind = 'v' then 'view'
        when pcl.relkind  = 'm' then 'materialized view,'
        when pcl.relkind  = 'c' then 'composite type'
        when pcl.relkind  = 't' then 'TOAST table'
        when pcl.relkind  = 'f' then 'foreign table'
    else null end as type
  ,relacl
from pg_class pcl join pg_user_info pui on (pcl.relowner = pui.usesysid)
join pg_namespace pna on (pcl.relnamespace = pna.oid)
where pna.nspname ilike :1 and relname ilike :2

