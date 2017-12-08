select 'Hydro',case when value='false' then 'Yes' else 'No' end value from settings where name = 'map.in.etl.prod' and client_id like @1 ;

