select (select TO_CHAR(min(time),'dd/mm/yy hh24:mi')  from dc_transaction_starts )as min_time,TO_CHAR(st.time,'dd/mm/yy hh24:mi:ss') AS sta_time
,TO_CHAR(en.time,'dd/mm/yy hh24:mi:ss')||'('||sysdate-en.time||')' "end_time(before)",en.time-st.time dur,en.transaction_id
,en.user_name,number_of_statements as num_stm
,dvros_rows_written,ros_rows_written,wos_rows_written,dvwos_rows_written
,substr(st.description,1,50) as description
from 
dc_transaction_starts  st join dc_transaction_ends en
on (st.transaction_id = en.transaction_id and st.node_name = en.node_name)
--where st.transaction_id = 45035996300635357
order by en.time-st.time desc 