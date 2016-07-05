
select settings.name,client_id, value from settings inner join clients on settings.client_id = clients.id and clients.active = 1 where settings.name like '%.rebuild.state.prod' and 
(settings.name  like 'wtf.%' or settings.name  like 'ytz.%') and client_id like '%' and lower(value) not in   ('LOADED','OK');

