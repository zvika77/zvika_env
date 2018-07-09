with lookup as
(select schema,table_name,table_id,sum(cont_queries) num_queries,count(usename) as num_users,listagg(usename,',') as users
from  (select distinct trim(schema) as schema,trim(svv_table_info.table)  as table_name, svv_table_info.table_id
from svv_table_info where database = 'prod'
--                          and schema = 'starterview' and svv_table_info.table = 'contact'
) tbls
left join (select  usename,tbl ,count(distinct query) cont_queries from stl_scan
join pg_user pui on (stl_scan.userid= pui.usesysid)
group by usename,tbl ) stl_scan
on (stl_scan.tbl = tbls.table_id)
group by schema,table_name,table_id
)
-- false positive is only the the original list excluding the ones we save for phase 1/2
, false_positive as
(select table_schema,table_name from admin.pii_orig
minus
select table_schema,table_name from admin.pii_filtered )
select * from
(SELECT
      lookup.table_id,
   svv_columns.table_schema,
   svv_columns.table_name,
    num_queries,
    num_users,
    count(column_name)        AS num_columns,
    listagg(column_name, ',') AS columns,
    users
 FROM svv_columns
   LEFT JOIN lookup ON (svv_columns.table_schema = lookup.schema AND svv_columns.table_name = lookup.table_name)
   JOIN svv_tables
     ON (svv_tables.table_schema = svv_columns.table_schema AND svv_tables.table_name = svv_columns.table_name)
 WHERE regexp_instr(column_name, 'name|addr|phone|email') > 0
       AND svv_columns.table_schema NOT IN
           ('pg_catalog', 'admin', 'information_schema', 'zendesk', 'mailchimp', 'facebook', 'market_spend')
       AND svv_columns.table_schema NOT LIKE 'tungsten%'
       AND svv_tables.table_type != 'VIEW'
 GROUP BY lookup.table_id, svv_columns.table_schema, svv_columns.table_name, num_queries, num_users, users
) b
 left join
 false_positive a on (a.table_schema = b.table_schema and a.table_name = b.table_name) -- get the rows exluding the rows from false positive
  left join admin.pii_filtered c on (b.table_schema = c.table_schema and b.table_name = c.table_name) -- get the rows excluding what we know about
where a.table_name is null
  and c.table_name is null
order by 2,3
