select * from stv_sessions where db_name = current_database() and (user_name ilike :1 or process = :1 )  order by starttime desc,user_name ;
