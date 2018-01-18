SELECT config.service_class AS queue ,
       TRIM (case when class.condition = '' then config.name else class.condition end ) AS description ,
            state.num_executing_queries||'/'||config.num_query_tasks AS slots ,
            state.num_queued_queries queued ,
            config.query_working_mem as "MemPerSlot",
            config.query_working_mem * config.num_query_tasks AS "memAllSlots" ,
            (config.max_execution_time/1000)::int AS max_time_sec ,
            config.user_group_wild_card AS "user_*" ,
            config.query_group_wild_card AS "query_*" ,
            state.num_executed_queries executed
FROM STV_WLM_CLASSIFICATION_CONFIG CLASS,
                                   STV_WLM_SERVICE_CLASS_CONFIG config,
                                   STV_WLM_SERVICE_CLASS_STATE STATE
WHERE CLASS.action_service_class = config.service_class
  AND CLASS.action_service_class = STATE.service_class
  AND config.service_class > 4
ORDER BY config.service_class;

