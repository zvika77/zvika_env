select
case when max(case when s.name = 'converter.state.generation.prod' then s.value else '' end) >
    max(case when s.name = 'wtf.loader.state.generation.esc.prod' then s.value else '' end)  then '===>' else '' end as active,
s.client_id,
v1.timezone,
max(case when s.name = 'converter.state.generation.prod' then s.value else '' end) ILP,
max(case when s.name = 'wtf.loader.state.generation.users.prod' then s.value else '' end) users,
max(case when s.name = 'wtf.loader.state.generation.events.prod' then s.value else '' end) events,
max(case when s.name = 'wtf.loader.state.generation.vh.prod' then s.value else '' end) view_hits,
max(case when s.name = 'converter.state.rebuild.generation.prod' then s.value else '' end) CLC,
# max(case when s.name = 'wtf.loader.rebuild.state.generation.users.prod' then s.value else '' end) users_rebuild,
# max(case when s.name = 'wtf.loader.rebuild.state.generation.events.prod' then s.value else '' end) events_rebuild,
# max(case when s.name = 'wtf.loader.rebuild.state.generation.vh.prod' then s.value else '' end) view_hits_rebuild,
max(case when s.name = 'viewmaterializer.state.hs.generation.prod' then s.value else '' end) HSM,
max(case when s.name = 'wtf.loader.state.generation.prod' then s.value else '' end) hits,
max(case when s.name = 'wtf.loader.state.generation.hs.prod' then s.value else '' end) hit_source,
# max(case when s.name = 'viewmaterializer.rebuild.state.hs.generation.prod' then s.value else '' end) HSM_rebuild,
# max(case when s.name = 'wtf.loader.rebuild.state.generation.hits.prod' then s.value else '' end) hits_rebuild,
# max(case when s.name = 'wtf.loader.rebuild.state.generation.hs.prod' then s.value else '' end) hit_source_rebuild,
max(case when s.name = 'viewmaterializer.state.esc.generation.prod' then s.value else '' end) ESCM,
max(case when s.name = 'wtf.loader.state.generation.esc.prod' then s.value else '' end) event_source_cache,
# max(case when s.name = 'viewmaterializer.rebuild.state.esc.generation.prod' then s.value else '' end) ESCM_rebuild,
# max(case when s.name = 'wtf.loader.rebuild.state.generation.esc.prod' then s.value else '' end) event_source_cache_rebuild,
# max(case when s.name = 'viewthroughconverter.state.generation.prod' then s.value else '' end) VTLC,
# max(case when s.name = 'converter.state.views.rebuild.generation.prod' then s.value else '' end) VTLC_rebuild,
max(case when s.name = 'wtf.loader.rebuild.state.generation.vt.prod' then s.value else '' end) views,
# max(case when s.name = 'wtf.loader.state.generation.vt.prod' then s.value else '' end) views_rebuild,
max(case when s.name = 'offline.sources.generation.prod' then s.value else '' end) OFFLINE_SRC,
max(case when s.name = 'wtf.loader.state.generation.offline_source.prod' then s.value else '' end) offline_sources,
max(case when s.name = 'offline.exposures.generation.prod' then s.value else '' end) OFFLINE_EXP,
max(case when s.name = 'wtf.loader.state.generation.offline_exposures.prod' then s.value else '' end) offline_exposures,
max(case when s.name = 'processed.by.esc.offline.sources.generation' then s.value else '' end) processed_by_esc_offline_sources_generation
from settings s
inner join clients c on s.client_id = c.id and c.active=1
inner join vw_client_data_status v1 on s.client_id =v1.client_id
     where s.client_id like @1
  group by client_id
order by 1 ,client_id;
