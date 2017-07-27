SET collation_connection = @@collation_database;

set @client = 'gap';
set @point_in_time = 1480063600;
set @quality = 'prod';


select @client client_id, converter_keys.name, clm.load_id value from (
select concat('converter.state.generation.', @quality) 'name', 'pipeline' load_type union all
select concat('viewmaterializer.state.hs.generation.', @quality)'name', 'pipeline' load_type union all
select concat('viewmaterializer.state.esc.generation.', @quality) 'name', 'pipeline' load_type union all
select concat('viewthroughconverter.state.generation.', @quality) 'name', 'pipeline.views' load_type) converter_keys
inner join (select load_type, load_id from client_loading_metadata where client_id = @client and env = @quality and load_type in ('pipeline', 'pipeline.views')
and start_ts < @point_in_time and end_ts >= @point_in_time GROUP BY 1,2) clm on converter_keys.load_type = clm.load_type
union all
select @client client_id, concat(clm1.subsystem_id, loader_gens.name) name, clm1.load_id value from (
select concat('.loader.state.generation.users.', @quality) 'name', 'pipeline' load_type union all
select concat('.loader.state.generation.events.', @quality) 'name', 'pipeline' load_type union all
select concat('.loader.state.generation.vh.', @quality) 'name', 'pipeline' load_type union all
select concat('.loader.state.generation.', @quality) 'name', 'pipeline' load_type union all
select concat('.loader.state.generation.hs.', @quality) 'name', 'pipeline' load_type union all
select concat('.loader.state.generation.esc.', @quality) 'name', 'pipeline' load_type union all
select concat('.loader.state.generation.vt.', @quality) 'name', 'pipeline.views' load_type) loader_gens inner join
(select subsystem_id, load_type, load_id from client_loading_metadata where client_id = @client and env = @quality and load_type in ('pipeline', 'pipeline.views')
and start_ts < @point_in_time and end_ts >= @point_in_time) clm1 on clm1.load_type = loader_gens.load_type
union all
select @client client_id, concat('converter.state.time.', @quality), end_ts value from client_loading_metadata where client_id = @client and env = @quality and load_type = 'pipeline'
and start_ts < @point_in_time and end_ts >= @point_in_time group by 1,2,3;


select  concat('delete consolidated files from ' , convert_tz(from_unixtime(start_ts), @@global.time_zone, 'UTC') , '-UTC and on...') instructions
from client_loading_metadata where client_id = @client and env = @quality and load_type = 'pipeline' and start_ts < @point_in_time and end_ts >= @point_in_time group by 1;

