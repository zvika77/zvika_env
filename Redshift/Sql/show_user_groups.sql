SELECT
pg_group.groname,
pg_user.usename
FROM pg_group, pg_user
WHERE pg_user.usesysid = ANY(pg_group.grolist)
and (groname  ilike  :1 or usename ilike :1 )
ORDER BY 1,2
;
