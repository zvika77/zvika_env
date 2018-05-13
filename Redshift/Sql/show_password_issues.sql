SELECT recordtime,trim(username) as username ,trim(oldusername) as oldusername,action,usecreatedb,usesuper,usecatupd,valuntil,pid,xid 
from stl_userlog where action = 'create'and userid not in (select userid from stl_utilitytext where label = 'default' and sequence = 0 and regexp_instr(text,'\\s*alter.*user.*password') > 0 )
order by recordtime
