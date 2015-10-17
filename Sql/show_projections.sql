select projection_schema,projection_name,owner_name,anchor_table_name,is_prejoin,create_type
,verified_fault_tolerance,is_up_to_date,has_statistics,is_segmented
from v_catalog.projections
where
(upper(projection_schema) ilike upper(:1) or upper(owner_name) ilike upper(:1) )
and (upper(projection_name) ilike upper(:2) or upper(anchor_table_name) ilike upper(:2))

