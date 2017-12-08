select * from storage_locations
where node_name ilike :1 or location_path ilike :1 or location_usage ilike :1 or location_label ilike :1
order by node_name
