select qr.client_id, s.value, healthCheckPass,completed,complete,delivered,delivery_retries_count,started
from queued_reports qr left join settings s
    on (s.client_id = qr.client_id and s.name = 'client time zone')
where started >= date(DATE_SUB(NOW(), INTERVAL 1 DAY))
and complete = 0
order by started;

