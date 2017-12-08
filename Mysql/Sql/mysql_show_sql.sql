select id,user,HOST,DB,COMMAND,TIME,STATE,INFO from information_schema.processlist where user like @1 or host like @1 or id = @1 order by time;
