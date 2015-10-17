/opt/vertica/bin/vsql -U vertica -w ${PASS} -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_ACCOUNT where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_account.gz
/opt/vertica/bin/vsql -U vertica -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_AGENT where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_agent.gz
/opt/vertica/bin/vsql -U vertica -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_AGENT_GROUP where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_agent_group.gz
/opt/vertica/bin/vsql -U vertica -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_BUTTON_STATUS " | gzip > dim_button_status.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_CALL_TYPE " | gzip > dim_call_type.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_CHANNEL " | gzip > dim_channel.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_CONVERSION_DEF where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_conversion_def.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_ENG_END_REASON " | gzip > dim_eng_end_reason.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_ENG_START_REASON " | gzip > dim_eng_start_reason.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_IMD_APPROACH_TYPE " | gzip > dim_imd_approach_type.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_IMPRESSION_OBJECT where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_impression_object.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_PRIVILEGE_GROUP where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_privilege_group.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_RESPONSE " | gzip > dim_response.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_RULE_SEGMENT where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_rule_segment.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_SEGMENT where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_segment.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_SERVICE_QUEUE where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_service_queue.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_SKILL where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > dim_skill.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.DIM_SURVEY_TYPE " | gzip > dim_survey_type.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.ERR_DIMS " | gzip > err_dims.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.MAP_AGENT_TO_SKILL where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > map_agent_to_skill.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.MAP_SEGMENT_TO_ASSIGNED_SEGMENT where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > map_segment_to_assigned_segment.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.MAP_SEGMENT_TO_ENTITY where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > map_segment_to_entity.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.MAP_SEGMENT_TO_LABEL where LP_ACCOUNT_ID in ('84421077', '5296924')" | gzip > map_segment_to_label.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.REP_NORM_DIMS " | gzip > rep_norm_dims.gz
/opt/vertica/bin/vsql -U vertica  -w ${PASS} -h svpr-dbv05 -At -c "select * from site_data.version " | gzip > version.gz
