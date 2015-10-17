select 
   start_time::timestamptz as start_time,
   node_name,
   round(100 -
          ((idle_microseconds_end_value - idle_microseconds_start_value)::float /
            (user_microseconds_end_value + nice_microseconds_end_value + system_microseconds_end_value
             + idle_microseconds_end_value + io_wait_microseconds_end_value + irq_microseconds_end_value
             + soft_irq_microseconds_end_value + steal_microseconds_end_value + guest_microseconds_end_value
             - user_microseconds_start_value - nice_microseconds_start_value - system_microseconds_start_value
             - idle_microseconds_start_value - io_wait_microseconds_start_value - irq_microseconds_start_value
             - soft_irq_microseconds_start_value - steal_microseconds_start_value - guest_microseconds_start_value)
           ) * 100, 2.0) cpu_usage
FROM dc_cpu_aggregate_by_second
where node_name ilike :1
--where start_time::timestamptz at timezone 'UTC' > sysdate::timestamptz at timezone 'UTC'  - interval '5 minute'
order by start_time::timestamptz desc;

