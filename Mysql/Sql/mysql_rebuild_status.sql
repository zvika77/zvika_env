
select settings.name,client_id, value from settings inner join clients on settings.client_id = clients.id and clients.active = 1 where settings.name like '%.rebuild.state.prod' 
and settings.name not like 'dcp.%' and client_id like @1 and lower(value) like @2;

select * from (
select settings.name, client_id, case when length(value)=0 then 'rebuild' else value end  as generation from settings inner join clients on settings.client_id = clients.id and clients.active = 1 where settings.name like '%loader.state.generation%prod' and settings.name not like 'dcp.%' and settings.client_id like  @1  ) a 
where generation like @2
order by 2, 1;
