select 'TABLE' as type,table_schema,table_name,partition_expression as info from v_catalog.tables where table_schema ilike :1 and table_name ilike :2
union all
select 'PROJECTION' as type ,projection_schema,projection_name,'Table Name: '||anchor_table_name as info from v_catalog.projections where projection_schema ilike :1 and projection_name ilike :2
union all
select  'SEQUENCE' as type,sequence_schema,sequence_name,'Table Name: '||identity_table_name as info from v_catalog.sequences where sequence_schema ilike :1 and sequence_name ilike :2
union all
select 'FUNCTION' as type,schema_name,function_name,procedure_type as info from v_catalog.user_functions where schema_name ilike :1 and function_name ilike :2
union all
select 'PROCEDURE' as type,schema_name,procedure_name,'' as info from v_catalog.user_procedures where schema_name ilike :1 and procedure_name ilike :2   
union all
select 'VIEWS' as type,table_schema,table_name,'Created:  '||create_time as info from v_catalog.views where table_schema ilike :1 and table_name ilike :2
union all
select 'CONSTRINT',constraint_name,table_schema||'.'||table_name as name,column_name||'  Type: '||constraint_type from v_catalog.constraint_columns  where table_schema ilike :1 and constraint_name ilike :2


