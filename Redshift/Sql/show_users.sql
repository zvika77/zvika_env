SELECT usesysid,usename,groname,usecreatedb,usesuper,usecatupd,valuntil,useconfig
FROM pg_user left join pg_group
on (pg_user.usesysid = ANY(pg_group.grolist))
where (groname  ilike  :1  or usename ilike :1 )
ORDER BY 1,2

