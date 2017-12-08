select id,user,HOST,DB,COMMAND,TIME,STATE,substr(INFO,1,100) as info from information_schema.processlist where (user like @1 or host like @1 ) and command = 'Query' order by time;
