select stp.name,stl.* from STV_LOCKS stl join (select distinct id,name from stv_tbl_perm)  stp on  (stl.table_id = stp.id)
