select 'edpo' as tname, max(date) as max_date from exp_dash_performance_optimization where client = :1
union all
select 'dpo', max(date) from dash_performance_optimization where client = :1
union all
select 'das', max(date) from dash_assist_sources where client = :1
union all
select 'esc',max(date(to_timestamp_tz(event_ts))) max_date from public.event_source_cache where client = :1;
