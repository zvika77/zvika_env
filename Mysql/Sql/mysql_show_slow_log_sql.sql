select start_time,query_time,rows_examined,rows_sent,sql_text from mysql.slow_log  where user_host like @1;
