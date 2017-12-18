select nspname,usename,nspacl from pg_namespace pna join pg_user_info pui on (pna.nspowner = pui.usesysid) where nspname ilike :1
