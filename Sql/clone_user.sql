SELECT 'CREATE USER '||:2||' IDENTIFIED BY '''||:2||'_#u'' ACCOUNT ' ||
          DECODE(is_locked, 't', 'lock', 'unlock') ||
          DECODE(memory_cap_kb, 'unlimited', '', ' MEMORYCAP ''' || memory_cap_kb, 'K''') ||
          ' PROFILE ' || profile_name ||
          ' RESOURCE POOL ' || resource_pool ||
          DECODE(run_time_cap, 'unlimited', '', ' RUNTIMECAP ''' || run_time_cap, 'K''') ||
          DECODE(temp_space_cap_kb, 'unlimited', '', ' TEMPSPACECAP ''' || temp_space_cap_kb, 'K''') || ';'
  FROM v_catalog.users
 WHERE user_name = :1
 UNION ALL
SELECT 'GRANT USAGE ON RESOURCE POOL ' || resource_pool || ' TO '||:2||' ;'
  FROM v_catalog.users
 WHERE user_name = :1
 UNION ALL
SELECT 'GRANT ' || name || ' TO '||:2||'' || CASE WHEN INSTR(all_roles, name || '*') > 0 THEN ' WITH GRANT OPTION' ELSE '' END || ';'
  FROM v_catalog.users
  JOIN v_catalog.roles
    ON INSTR(all_roles, name) > 0
 WHERE user_name = :1
UNION ALL
select 'ALTER USER '||:2||' DEFAULT ROLE '||default_roles||';'
from v_catalog.users
WHERE user_name = :1
 UNION ALL
(SELECT 'GRANT ' || name || ' ON ' || DECODE(name, 'USAGE', 'SCHEMA ', object_schema || '.') || object_name || ' TO '||:2||' ' ||
          CASE WHEN INSTR(privileges_description, name || '*') > 0 THEN ' WITH GRANT OPTION' ELSE '' END || ';'
   FROM v_catalog.grants
   JOIN (SELECT 'USAGE'
          UNION
         SELECT 'INSERT'
          UNION
         SELECT 'SELECT'
          UNION
         SELECT 'UPDATE'
          UNION
         SELECT 'DELETE'
          UNION
         SELECT 'REFERENCES') AS foo (name)
     ON INSTR(privileges_description, name) > 0
    AND object_name <> 'general'
  WHERE grantee = :1
  ORDER BY 1 DESC);
