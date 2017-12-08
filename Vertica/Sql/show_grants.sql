select grantee,privileges_description,object_schema,object_name,grantor
from v_catalog.grants
where (grantee ilike :1 or grantor ilike :1 or object_name ilike :1 )
order by grantee

