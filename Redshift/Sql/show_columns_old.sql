select table_catalog,table_schema,table_name,column_name,data_type
  ,case data_type when ('integer')  then numeric_precision::INTEGER
   when 'character varying' then character_maximum_length::INTEGER end as "length"
,column_default,is_nullable
from SVV_COLUMNS  where table_schema  = :1 and table_name ilike :2 order by 1,2,3,ordinal_position
