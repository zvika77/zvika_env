select schema_owner,schema_name,create_time
from schemata
where schema_owner ilike :1
or schema_name ilike :1 
order by create_time desc 
;

