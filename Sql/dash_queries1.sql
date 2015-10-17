\timing 
select * from execution_engine_profiles where session_id=(select session_id from current_session);
--select * from query_plan_profiles where session_id=(select session_id from current_session);
select * from query_events where session_id=(select session_id from current_session);
