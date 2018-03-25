select xid||'/'||pid||'/'||query as "xid/pid/query",sequence,text  from stl_querytext where (xid = :1 or query = :1 or pid = :1) order by query,sequence 
