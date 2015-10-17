select client_id,data_lag_hrs,dashv2_lag_hrs,freshness_date,dashv2_freshness_date,tz,client_date,client_hour,ilp_timestamp,ilp_date,eod_gen,ilp_gen,hs_loader_gen,esc_loader_gen,hsm_gen,esc_gen,esc_gen_date from (
                    select * from(
                    select
                    client_id,
                    freshness_date,
                    data_lag_hrs,
                    case when real_freshness_date=dashv2_freshness_date then freshness_date else dashv2_freshness_date end dashv2_freshness_date,
                    tz,client_date,client_hour,
                    clc_timestamp ilp_timestamp,
                    ilp_date,
                    ilp_gen,
                    hs_loader_gen,
                    esc_loader_gen,
                    esc_gen_date,
                    case when real_freshness_date=dashv2_freshness_date then data_lag_hrs else dashv2_lag_hrs end dashv2_lag_hrs,
                    client_now,
                    real_freshness_date,
                    hsm_gen,
                    esc_gen,
                    eod_gen
                    from (
                    select
                    q1.client_id,
                    freshness_date real_freshness_date,
                    case when client_date > freshness_date and esc_gen_date> client_date then date(esc_gen_date) else freshness_date end freshness_date,
                    case when client_date > freshness_date and esc_gen_date> client_date then timestampdiff(MINUTE, from_unixtime(esc_gen_timestamp), now() )/ 60 else data_lag_hrs end data_lag_hrs,
                    dashv2_freshness_date,
                    tz,client_date,client_hour,
                    clc_timestamp,
                    ilp_date,
                    ilp_gen,
                    hs_loader_gen,
                    esc_loader_gen,
                    esc_gen_date,
                    dashv2_lag_hrs,
                    client_now,
                    hsm_gen,
                    esc_gen,
                    eod_gen
                    from
                    (
                    select pm.client_id,
                    timestampdiff(MINUTE, from_unixtime(data_end_ts_esc), now() )/ 60  data_lag_hrs,
                    date(CONVERT_TZ( from_unixtime(data_end_ts_esc), @@global.time_zone, tz )) freshness_date,
                    CONVERT_TZ( from_unixtime(clc_time), @@global.time_zone, tz ) as ilp_date,
                    tz,
                    date(client_now) as client_date,
                    hour(client_now) + minute(client_now)/60 client_hour,
                    clc_time clc_timestamp,
                    ilp_gen,
                    hs_loader_gen,
                    esc_loader_gen,
                    hsm_gen,
                    esc_gen,
                    esc_gen_date esc_gen_timestamp,
                    CONVERT_TZ( from_unixtime(esc_gen_date), @@global.time_zone, tz ) as esc_gen_date,
                    date(CONVERT_TZ( from_unixtime(data_end_ts_dv2), @@global.time_zone, tz )) dashv2_freshness_date,
                    timestampdiff(MINUTE, from_unixtime(data_end_ts_dv2), now() )/ 60  dashv2_lag_hrs,
                    client_now,
                    eod_gen

                    from
                    (
                    select
                    client_id,
                    max(CASE WHEN data_type = 'event_source_cache' and subsystem_id = 'wtf' then data_end_ts else 0 end) data_end_ts_esc,
                    max(CASE WHEN data_type = 'max_processing_ts' and subsystem_id = 'dv2' then data_end_ts else 0 end) data_end_ts_dv2
                    from processing_metadata
                    where ((data_type = 'event_source_cache' and subsystem_id = 'wtf' and process_type = 'loader'  and load_id <> -1) or
                    (data_type = 'max_processing_ts' and subsystem_id = 'dv2' and process_type = 'load' ))
                    and load_id is not null
                    group by client_id

                    ) pm left join
                    (
                     select s.*, timezone tz, esc_max_processing_ts esc_gen_date from vw_client_data_status s
                    ) s
                    on (pm.client_id = s.client_id)
                    where
                    pm.client_id not in ('square','trendmicro','insight','beachbody','dailyburn','dermstore','topspin','astro_gaming','ppca','pennfoster','anntaylor','relayfoods','cordblood','echosign','esalon','echostar','watson','sttropez','acmg','nfl','garage_doors','dogvacay','banana','zinroncar','brilliantearth','kraft')
                    ) q1) q2) q3
                    where ((( (client_date > freshness_date and data_lag_hrs > 6 )  or dashv2_lag_hrs > 20 ) and ( client_hour >= 4.5 ) ) or (coalesce(eod_gen,-1)<0  and client_hour>2.5)) and esc_loader_gen>-1 and
                    client_id in (select id from clients where active = 1)
                    order by client_hour desc
                    ) tb
