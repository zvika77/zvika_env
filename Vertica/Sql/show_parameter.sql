select node_name,parameter_name,current_value as curr_val,default_value as def_val
,change_under_support_guidance as support_change,
change_requires_restart as require_restart
,description
from v_monitor.configuration_parameters
where parameter_name ilike :1;
