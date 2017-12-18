\x
select schemaname,viewname,viewowner,definition from pg_views where schemaname = :1 and viewname = :2 order by 1,2
