select substr(host,1,instr(host,':')-1) as host,command,count(*) from information_schema.processlist group by substr(host,1,instr(host,':')-1),command  order by 3,1;
