SELECT node_name,transaction_id,statement_id, counter_name, counter_value, operator_name
         from execution_engine_profiles WHERE is_executing='t'
         AND counter_name IN ('rows received') AND Operator_name IN ('Import')
and transaction_id = :1 and statement_id = :2
order by node_name;
