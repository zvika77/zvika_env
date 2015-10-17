SELECT
    c.* ,
    p.projection_schema ,
    p.anchor_table_name ,
    p.projection_name
FROM
    (
        SELECT
            projection_id ,
            node_name ,
            partition_key ,
            COUNT(1) ros_count
        FROM
            v_monitor.partitions
        GROUP BY
            1 ,
            2 ,
            3
    ) c JOIN projections p
        USING(projection_id)
        where p.projection_schema ilike :1
        and p.anchor_table_name ilike :2
        and p.projection_name ilike :3
ORDER BY
    c.ros_count DESC

