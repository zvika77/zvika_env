SELECT DISTINCT s3.active,
                q1.client_id,
                tz_offset,
                ifnull(priority, 0) AS priority,
                hour(timediff(esc_freshness_ts, dv2_freshness_ts)) AS lag_hrs,
                q1.tz,
                datediff(esc_freshness_ts, dv2_freshness_ts) AS lag_days,
                s1.value AS escRebuildFlag,
                s2.value AS allRebuildFlag,
                esc_freshness_ts,
                dv2_freshness_ts
FROM
  (SELECT pm.client_id,
          priority,
          timestampdiff(MINUTE, from_unixtime(data_end_ts), now())/ 60 AS freshness_hrs,
          timestamp(CONVERT_TZ(from_unixtime(data_end_ts), @@global.time_zone, ifnull(value, 'America/Los_Angeles'))) AS esc_freshness_ts,
          date(CONVERT_TZ(from_unixtime(data_end_ts), @@global.time_zone, ifnull(value, 'America/Los_Angeles'))) AS esc_freshness_date,
          ifnull(value, 'America/Los_Angeles') AS tz,
          (unix_timestamp() - unix_timestamp(convert_tz(now(), 'UTC', ifnull(value, 'America/Los_Angeles')))) / 3600 AS tz_offset,
          date(CONVERT_TZ(now(), @@global.time_zone, ifnull(value, 'America/Los_Angeles'))) AS cur_date,
          hour(CONVERT_TZ(now(), @@global.time_zone,ifnull(value, 'America/Los_Angeles'))) AS cur_hour
   FROM processing_metadata pm
   LEFT JOIN
     (SELECT *
      FROM settings
      WHERE name = 'client time zone') s ON (pm.client_id = s.client_id)
   LEFT JOIN
     (SELECT DISTINCT client_id,
                      cast(value AS UNSIGNED) AS priority
      FROM settings
      WHERE client_id IS NOT NULL
        AND user_id IS NULL
        AND name = 'client report priority') p ON (pm.client_id = p.client_id)
   WHERE data_type = 'event_source_cache'
     AND subsystem_id = 'wtf'
     AND process_type = 'loader'
     AND pm.client_id IN
       (SELECT id
        FROM clients
        WHERE active = 1)
     AND load_id IS NOT NULL
     AND load_id <> -1) q1
LEFT JOIN
  (SELECT pm.client_id,
          timestampdiff(MINUTE, from_unixtime(data_end_ts), now())/ 60 AS freshness_hrs,
          date_sub(timestamp(CONVERT_TZ(from_unixtime(data_end_ts), @@global.time_zone, ifnull(value, 'America/Los_Angeles'))), interval 1 DAY) AS dv2_freshness_ts,
          ifnull(value, 'America/Los_Angeles') AS tz,
          date(CONVERT_TZ(now(), @@global.time_zone, ifnull(value, 'America/Los_Angeles'))) AS cur_date,
          timestamp(CONVERT_TZ(now(), @@global.time_zone,ifnull(value, 'America/Los_Angeles'))) AS cur_hour
   FROM processing_metadata pm
   LEFT JOIN
     (SELECT client_id,
             value
      FROM settings
      WHERE name = 'client time zone') s ON (pm.client_id = s.client_id)
   WHERE data_type = 'max_processing_ts'
     AND subsystem_id = 'dv2'
     AND process_type = 'load'
     AND pm.client_id IN
       (SELECT id
        FROM clients
        WHERE active = 1)) q2 ON q1.client_id = q2.client_id
LEFT JOIN
  (SELECT client_id,
          value
   FROM settings
   WHERE name='wtf.esc.rebuild.state.prod') s1 ON q1.client_id=s1.client_id
LEFT JOIN
  (SELECT client_id,
          value
   FROM settings
   WHERE name='wtf.rebuild.state.prod') s2 ON q1.client_id=s2.client_id
  left join
(SELECT client,'===>' as active
      FROM dashv2_etl_stats
       WHERE job_run_status = '') s3 on q1.client_id=s3.client
WHERE datediff(esc_freshness_ts, dv2_freshness_ts) > 1
  AND q1.client_id NOT IN
    (SELECT DISTINCT client_id
     FROM settings
     WHERE name IN ('wtf.rebuild.state.prod',
                    'wtf.esc.rebuild.state.prod')
       AND value NOT IN ('LOADED',
                         'OK'))
  AND ifnull(s1.value,'OK') != 'LOADED'
  AND ifnull(s2.value,'OK') != 'LOADED'
  AND q1.client_id NOT IN
    (SELECT DISTINCT client_id
     FROM settings
     WHERE client_id IN ('kraft')
       AND name LIKE '%rebuild.state.prod') -- do not do anything to kraft on prod automatically
# AND q1.client_id NOT IN
#     (SELECT DISTINCT client
#      FROM dashv2_etl_stats
#      WHERE job_run_status = '')
ORDER BY 3 ASC, 4 DESC, 5 DESC , 1 ;
