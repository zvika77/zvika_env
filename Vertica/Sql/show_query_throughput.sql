select
qpo.user_name,
substr(replace(query,chr(10),' '),1,50) as query,
(query_duration_us/1000000)::numeric(10,2) as Sec,
processed_row_count as rows,
error_code as err
from query_profiles qpo
where qpo.user_name = :1
--and processed_row_count = 9
order by query_duration_us desc
