\x
select  *
from query_events a
where transaction_id = :1
and statement_id = :2
