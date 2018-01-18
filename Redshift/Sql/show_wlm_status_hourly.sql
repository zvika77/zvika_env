WITH -- Replace STL_SCAN in generate_dt_series with another table which has > 604800 rows if STL_SCAN does not
 generate_dt_series AS
  (SELECT sysdate - (n * interval '1 second') AS dt
   FROM
     (SELECT row_number() over () AS n
      FROM stl_scan LIMIT 86400)),
 apex AS
  (SELECT iq.dt,
          iq.service_class,
          iq.name,
          iq.num_query_tasks,
          count(iq.slot_count) AS service_class_queries,
          sum(iq.slot_count) AS service_class_slots
   FROM
     (SELECT gds.dt,
             wq.service_class,
             wscc.name,
             wscc.num_query_tasks,
             wq.slot_count
      FROM stl_wlm_query wq
      JOIN stv_wlm_service_class_config wscc ON (wscc.service_class = wq.service_class
                                                 AND wscc.service_class > 4)
      JOIN generate_dt_series gds ON (wq.service_class_start_time <= gds.dt
                                      AND wq.service_class_end_time > gds.dt)
      WHERE wq.userid > 1
        AND wq.service_class > 4) iq
   GROUP BY iq.dt,
            iq.service_class,
            iq.name,
            iq.num_query_tasks),
 maxes AS
  (SELECT apex.service_class,apex.name,
          trunc(apex.dt) AS d,
          date_part(h,apex.dt) AS dt_h,
          max(service_class_slots) max_service_class_slots
   FROM apex
   GROUP BY apex.service_class,apex.name,
            apex.dt,
            date_part(h,apex.dt))
select TRIM (case when class.condition = '' then final.name else class.condition end ) AS service_class,
        wlm_slots,
        DAY,hour,
        max_slots_used
from (        
SELECT 
       apex.service_class,maxes.name,
       apex.num_query_tasks AS wlm_slots,
       maxes.d AS DAY,
       maxes.dt_h || ':00 - ' || maxes.dt_h || ':59' AS hour,
                                 MAX(apex.service_class_slots) AS max_slots_used
FROM apex
JOIN maxes ON (apex.service_class = maxes.service_class
               AND apex.service_class_slots = maxes.max_service_class_slots)
GROUP BY apex.service_class,maxes.name,
         apex.num_query_tasks,
         maxes.d,
         maxes.dt_h
         ) final
JOIN STV_WLM_CLASSIFICATION_CONFIG CLASS on (CLASS.action_service_class = final.service_class)         
ORDER BY final.service_class,
         final.day,
         final.hour

