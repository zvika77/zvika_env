select listagg(text,'')  within group (order by sequence) from stl_querytext where (xid = :1 or query = :1 or pid = :1)
