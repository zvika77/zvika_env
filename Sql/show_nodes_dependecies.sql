SELECT dependency_id, MIN (node_name) node_x, MAX(node_name) node_y, 
   COUNT(*) dep_count FROM vs_node_dependencies JOIN nodes ON (node_oid = node_id) 
   GROUP BY 1 ORDER BY 1; 
