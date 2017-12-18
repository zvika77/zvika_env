select schemaname,viewname,viewowner,substring(definition,1,100) as definition from pg_views where schemaname = :1 and viewname ilike :2 order by 1,2
