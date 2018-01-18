WITH qd AS
  (SELECT 'completed'::text status,
                            svl_query_report.segment,
                            svl_query_report.step,
                            svl_query_report.label,
                            min(svl_query_report.start_time) start_time,
                                                             max(svl_query_report.end_time) end_time,
                                                                                            max(svl_query_report.elapsed_time) max_elapsed_time,
                                                                                                                               min(svl_query_report.elapsed_time) min_elapsed_Time,
                                                                                                                                                                   avg(svl_query_report.elapsed_time) avg_elapsed_time,
                                                                                                                                                                                                      sum(svl_query_report.rows) "rows",
sum(svl_query_report.bytes) bytes,
                            sum(CASE WHEN svl_query_report.is_diskbased='t' THEN 1 ELSE 0 END) is_diskbased,
                                                                                               sum(workmem) AS workmem,
                                                                                               sum(CASE WHEN svl_query_report .is_rrscan='t' THEN 1 ELSE 0 END) is_rrscan,
                                                                                                                                                                sum(svl_query_report.rows_pre_filter) "rows_pre_filter"
   FROM svl_query_report
WHERE svl_query_report.query = :1
   GROUP BY svl_query_report.segment,
            svl_query_report.step,
            svl_query_report.label)
SELECT DISTINCT xpl.nodeid,
              xpl.parentid,
              xpl. plannode AS plan_text,
              xpl.info AS plan_info,
              pl.locus,
              qd.start_time,
              qd.end_Time,
              qd.status,
              stm.stream,
              qd.segment,
              qd.step,
              qd.label,
              qd.min_elapsed_time,
              qd.avg_elapsed_time,
              qd.max_elapsed_time,
              qd.workmem,
              pl.rows AS estimated_rows,
              qd.rows,
              qd.rows_pre_filter,
              pl.bytes AS estimated_bytes,
              qd.bytes,
              CASE
                WHEN qd.is_diskbased=0 THEN 'F'
                ELSE 'T'
            END AS is_diskbased,
              CASE
                WHEN qd.is_rrscan=0 THEN 'F'
                ELSE 'T'
            END AS is_rrscan,
              alert.event,
              alert.solution
FROM stl_explain xpl
LEFT OUTER JOIN stl_plan_info pl ON xpl.query = pl.query and xpl.nodeid = pl.nodeid and pl.query = :1
LEFT OUTER JOIN qd ON qd.segment = pl.segment
AND qd.step = pl.step
LEFT OUTER JOIN stl_stream_segs stm ON stm.segment = qd.segment
AND stm.query = xpl.query
AND stm.query = :1
LEFT OUTER JOIN
(SELECT DISTINCT segment,
                 step,
                 trim(split_part(event,':',1)) AS event,
                 trim(solution) AS solution,
                 query AS query
 FROM stl_alert_event_log
 WHERE query = :1) alert on alert.segment=pl.segment
AND alert.step = pl.step
AND alert.query=pl.query
WHERE xpl.query = :1
ORDER BY xpl.nodeid,
       xpl.parentid,
       segment,
       step
