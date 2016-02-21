select client_id, mode, count(*)
 from insight.queued_reports qr
 where qr.complete = 0
 and qr.delivered = 0
 and started >= DATE_SUB(NOW(), INTERVAL 1 DAY)
group by 1, 2
order by 3 desc;


select qr.client_id, s.value, healthCheckPass,completed,complete,delivered,delivery_retries_count,started
from queued_reports qr left join settings s
    on (s.client_id = qr.client_id and s.name = 'client time zone')
where started >= date(DATE_SUB(NOW(), INTERVAL 1 DAY))
and complete = 0
order by started;

