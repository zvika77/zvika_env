SELECT *
FROM  pg_tables pta 
WHERE pta.schemaname ILIKE :1
  AND pta.TABLENAME ILIKE :2
ORDER BY 1,
         2,
         3
