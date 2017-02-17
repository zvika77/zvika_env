SELECT transaction_id,
          statement_id,
          session_id,
          sum(CASE WHEN counter_tag = 'main'
              AND counter_name = 'input size (bytes)'
              AND (operator_name = 'Load'
                   OR operator_name = 'LoadUnion') THEN 1 ELSE 0 END) AS total_rows,
          sum(CASE WHEN operator_name = 'Load'
              AND counter_name = 'rows produced' THEN counter_value ELSE 0 END) AS accepted_row_count,
          sum(CASE WHEN operator_name = 'Load'
              AND counter_name = 'rows rejected' THEN counter_value ELSE 0 END) AS rejected_row_count,
          sum(CASE WHEN counter_name = 'read (bytes)'
              AND operator_name = 'Load' THEN (counter_value/1024/1024)::int ELSE 0 END) AS read_mb,
          sum(CASE WHEN counter_tag = 'main'
              AND counter_name = 'input size (bytes)'
              AND (operator_name = 'Load'
                   OR operator_name = 'LoadUnion') THEN (counter_value/1024/1024)::int ELSE 0 END) AS input_size_mb,
          count(CASE WHEN counter_tag = 'main'
                AND counter_name = 'input size (bytes)'
                AND (operator_name = 'Load'
                     OR operator_name = 'LoadUnion') THEN counter_value ELSE NULL END) AS num_not_nulls,
          sum(CASE WHEN counter_name = 'input rows'
              AND operator_name = 'DataTarget' THEN counter_value ELSE 0 END) AS unsorted_row_count,
          sum(CASE WHEN counter_name = 'written rows'
              AND operator_name = 'DataTarget' THEN counter_value ELSE 0 END) AS sorted_row_count
   FROM v_monitor.execution_engine_profiles
     where transaction_id = :1
       and statement_id = :2
   GROUP BY transaction_id,
            statement_id,
            session_id
