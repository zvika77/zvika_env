SELECT /*+label(zvika_cross_channel_perf)*/ source1 AS source1, SUM(value)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click, SUM(cost)::FLOAT AS cost, SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click FROM ( SELECT /*+label(zvika_cross_channel_perf)*/ '~' AS DATE, '~' AS site_name, source1 AS source1, '~' AS source2, '~' AS source3, SUM(clicks) AS clicks, SUM(impressions) AS impressions, SUM(VALUE) AS VALUE, SUM(frac_contribution) AS frac_contribution, SUM(tp_only) AS tp_only, SUM(tp_introducer) AS tp_introducer, SUM(tp_influencer) AS tp_influencer, SUM(tp_closer) as tp_closer, SUM(cost) AS cost FROM ( SELECT model, DATE, v_site_id as site_id, v_site_name AS site_name, source1, source2, '~' AS source3, SUM(impressions) AS impressions, SUM(clicks) AS clicks, SUM(VALUE) AS VALUE, SUM(frac_contribution) AS frac_contribution, SUM(tp_only) AS tp_only, SUM(tp_introducer) AS tp_introducer, SUM(tp_influencer) AS tp_influencer, SUM(tp_closer) as tp_closer, 0.0 AS cost FROM exp_dash_performance_optimization WHERE client = 'qvc' -- whitelist filter
           AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
           AND event_type NOT IN ('all events')
             -- site names
            -- event filters
           AND model IN ('Regression','-') -- model filters
         GROUP BY 
           1, 2, 3, 4, 5, 6, 7
 
 UNION ALL
 
         SELECT 
           '' model,
           DATE,
           site_id,
           site_name,
           source1,
           source2,
           '~' AS source3,
           0 AS impressions,
           0 AS clicks, 
           0.0 AS VALUE, 
           0.0 AS frac_contribution,
           0 AS tp_only,
           0 AS tp_introducer,
           0 AS tp_influencer,
           0 as tp_closer,
           SUM(cost) AS cost
         FROM 
           dash_ppc_cost 
         WHERE
           client = 'qvc'
           
           
           AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
             -- site names
         GROUP BY 
           1, 2, 3, 4, 5, 6, 7
         HAVING SUM(cost) > 0
 ) q1
 GROUP BY 
   1,2,3,4,5
 
 
 ) AS SRC GROUP BY 1  ORDER BY 1     LIMIT 10001 ;






select /*+label(zvika_dash_spend_rec_engine)*/ * from ( select source1,source2,source3, sum(x.cost) cost, sum(x.revenue) revenue, sum(x.conversions) conversions from ( select nvl(source1,' ') as source1,nvl(source2,' ') as source2,nvl(source3,' ') as source3 ,sum(q.cost) cost, sum(q.revenue) revenue, sum(q.conversions) conversions, sum(has_cost) has_cost, sum(has_revenue) has_revenue, 0 date from ( select source1,source2,source3, 0.0 cost, sum(d.value) revenue, sum(d.frac_contribution) conversions, 0 has_cost, 1 has_revenue from exp_dash_performance_optimization d where d.client = 'qvc' and d.model = 'Regression' and d.date >= '2014-12-01' and d.date < '2015-02-28' group by 1,2,3 union all select nvl(source1,' ') as source1,nvl(source2,' ') as source2,nvl(source3,' ') as source3, sum(t.cost) cost, 0.0 revenue, 0.0 conversions, 1 has_cost, 0 has_revenue from dash_ppc_cost t where client = 'qvc' and t.date >= '2014-12-01' and t.date < '2015-02-28' group by 1,2,3) q group by 1,2,3 ) x group by 1,2,3 order by 1,2,3 ) y where cost > 0;



SELECT /*+label(zvika_dash_geo)*/ country_code AS country, region AS region, dma_code AS dma, SUM(clicks)::INT AS clicks, SUM(value)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(frac_contribution)::FLOAT / SUM(clicks)::INT AS conversion_rate, SUM(cost)::FLOAT AS cost, SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click FROM ( select country_code, region, dma_code, SUM(clicks)::INT AS clicks, SUM(value)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, sum(cost)::FLOAT AS cost from ( select /*+label(zvika_dash_geo)*/ dt as date, v_site_id as site_id, v_site_name as site_name, source1, source2, source3, country_code, region, city, dma_code, case when cost_by_s1Dma > 0 then cost_by_s123Dma * (decode(cnt_dma, 0 ,1 ,grp_cnt/cnt_dma)) else cost_by_s123 * (decode(cnt, 0 ,1 ,grp_cnt/cnt)) end as cost, clicks, impressions, frac_contribution, rev as value from ( select src, dt, v_site_id, v_site_name, source1, source2, source3, country_code, region, city, dma_code, clicks, impressions, frac_contribution, rev, SUM(cost) over (partition by client, dt, v_site_id, v_site_name, source1, source2, source3 ) cost_by_s123, SUM(cost) over (partition by client, dt, v_site_id, v_site_name, source1, source2, source3, dma_code ) cost_by_s123Dma, cost_by_s1Dma, decode(src,'r',decode(clicks + impressions,0,1,clicks + impressions),0) as grp_cnt, SUM(decode(src,'r',decode(clicks + impressions,0,1,clicks + impressions),0)) over (partition by client, dt, v_site_id, v_site_name, source1, source2, source3) cnt, SUM(decode(src,'r',decode(clicks + impressions,0,1,clicks + impressions),0)) over (partition by client, dt, v_site_id, v_site_name, source1, source2, source3, dma_code) cnt_dma, COUNT(src) over (partition by client, -- this us used to keep the count of rows where there are no hits or unmatched cost
                   dt,
                   v_site_id,
                   v_site_name,
                   source1,
                   source2,
                   source3) src_cnt,
   COUNT(src) over (partition by client,  -- this us used to keep the count of rows where there are no hits or unmatched cost
                   dt,
                   v_site_id,
                   v_site_name,
                   source1,
                   source2,
                   source3,
                 dma_code) src_cnt_dma
   FROM (
           ------------------------------------------------------------------------
           SELECT
               client,
               model,
               date dt,
               v_site_id,
               v_site_name,
               source1,  -- to do: use channel, provider, etc
               source2,
               source3,
               country_code,
               region,
               dma_code,
               '~' AS city,
               'r' src,
               case when source1 = 'ooh' then 1 else 0 end as cost_by_s1Dma,
               sum(case when provider = 'offline_sources' then 0 else impressions end) as impressions, -- impressions from offline_exposures do not have geo
               sum(clicks) as clicks,
               sum(value) as rev,
               SUM(frac_contribution) AS frac_contribution,
               0.0 AS cost
           FROM
               dash_performance_optimization
           WHERE
               client = 'qvc'
                    -- whitelist filter
             AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
             AND event_type NOT IN ('all events')
             AND NOT (provider = 'offline_sources' AND impressions > 0 AND country_code is null )
               -- site names
              -- event filters
             AND model IN ('Regression','-') -- model filters
 
           GROUP BY
             1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
             -----------------------------------------------------------
             union all
             -----------------------------------------------------------
           select
           client,
           '' as model,
           date dt,
           site_id as v_site_id,
           site_name as v_site_name,
           source1,
           source2,
           source3,
           '' country_code,
           '' region,
           decode(dma_code, null, '', decode(dma_code, '0', '', dma_code)) dma_code,
           '' city,
           'c' src,
           case when source1 = 'ooh' then 1 else 0 end as cost_by_s1Dma,
           0 AS clicks,
           0 AS impressions,
           0.0 AS value,
           0.0 AS frac_contribution,
           SUM(cost) AS cost
         FROM
           dash_ppc_cost
         WHERE
         client = 'qvc'
         
         
           -- site names
         AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
         AND cost > 0 -- there are 0 cost rows reported- we dont need these.
         AND provider not in ('offline_sources', 'tv', 'radio')
           -- site names
         GROUP BY
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
             -----------------------------------------------------------
 
   ) q1
 ) q2
 
 Where (src='r' or ((cost_by_s1Dma = 0 and src_cnt = 1) or (cost_by_s1Dma = 1 and src_cnt_dma = 1)) ) -- catch rows where cost but no rev
 
 
 
    ) q1 group by 1,2,3  ) AS SRC GROUP BY 1,2,3  ORDER BY value DESC      LIMIT 10001 ;





SELECT /*+label(zvika_cross_channel_influence_chart)*/ source1 AS source1,
                                                 SUM(assist_value)::FLOAT AS assist_value,
                                                 SUM(closer_value)::FLOAT AS closer_value
FROM (
SELECT /*+label(zvika_cross_channel_influence_chart)*/ '~' AS DATE,
                                                 '~' AS site_name,
                                                 source1 AS source1,
                                                 sum(assist_value) AS assist_value,
                                                 sum(closer_value) AS closer_value
FROM
  (SELECT assist_source1 AS source1, v_site_name, site_name, date, sum(CASE WHEN assist_source1 <> closer_source1 THEN assist_value ELSE 0 END) AS assist_value,
                                                                   sum(CASE WHEN assist_source1 = closer_source1 THEN assist_value ELSE 0 END) closer_value
   FROM dash_assist_sources
   WHERE client = 'qvc' -- whitelist filter
AND DATE BETWEEN '2014-12-01' AND '2015-02-28' -- site names          -- event filters
AND model IN ('Regression',
              '-') -- model filters
   GROUP BY 1,
            2,
            3,
            4) q1
GROUP BY 1,
         2,
         3 -- ,4,5
 ) AS SRC GROUP BY 1  ORDER BY assist_value DESC      LIMIT 10001 ;    







SELECT /*+label(zvika_dash_device_chart_cost)*/ device AS device, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(clicks)::INT AS clicks FROM ( select /*+label(zvika_dash_device_chart_cost)*/ date, source1, device, frac_contribution, value, cost, clicks from ( select *, sum(value) over(partition by source1) as totalvalue, sum(cost) over() as totalcost from ( select /*+label(zvika_dash_device_cost)*/ dt as date, v_site_id as site_id, v_site_name as site_name, source1, source2, source3, decode(device,'','unknown',device) as device, cost_by_s123 * (decode(cnt, 0 ,1 ,grp_cnt/cnt)) as cost, -- case stmt: if event row exists with no hit/click data.
 clicks,
 impressions,
 frac_contribution,
 rev as value,
 tp_only,
 tp_introducer,
 tp_influencer,
 tp_closer
 
 from
 (
     select
     src,
     client,
     dt,
     v_site_id,
     v_site_name,
     source1,
     source2,
     source3,
     device,
     clicks,
     impressions,
     rev,
     frac_contribution,
     tp_only,
     tp_introducer,
     tp_influencer,
     tp_closer,
     SUM(cost) over (partition by client,
                   dt,
                   v_site_id,
                   v_site_name,
                   source1,
                   source2,
                   source3
                   ) cost_by_s123,
     decode(src,'r',decode(clicks + impressions,0,1,clicks + impressions),0) as grp_cnt,
     SUM(decode(src,'r',decode(clicks + impressions,0,1,clicks + impressions),0)) over (partition by client,
                   dt,
                   v_site_id,
                   v_site_name,
                   source1,
                   source2,
                   source3) cnt,
     COUNT(src) over (partition by client,  -- this us used to keep the count of rows where there are no hits or unmatched cost
                   dt,
                   v_site_id,
                   v_site_name,
                   source1,
                   source2,
                   source3) src_cnt
 
 
     FROM (
             SELECT
             client,
             model,
             date dt,
             v_site_id,
             v_site_name,
             source1,
             source2,
             '~' AS source3,
             device,
             'r' src,
             SUM(impressions) as impressions,
             SUM(clicks) as clicks,
             SUM(value) as rev,
             SUM(frac_contribution) AS frac_contribution,
             0.0 AS cost,
             SUM(tp_only) AS tp_only,
             SUM(tp_introducer) AS tp_introducer,
             SUM(tp_influencer) AS tp_influencer,
             SUM(tp_closer) as tp_closer
             FROM
             exp_dash_performance_optimization
             WHERE
             client = 'qvc'
                  -- whitelist filter
             AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
             AND event_type NOT IN ('all events')
               -- site names
              -- event filters
             AND model IN ('Regression','-') -- model filters
 
 
             GROUP BY
             1, 2, 3, 4, 5, 6, 7, 8, 9, 10
 
             -----------------------------------------------------------
             union all
             -----------------------------------------------------------
             SELECT
             client,
             '' as model,
             date dt,
             site_id as v_site_id,
             site_name as v_site_name,
             source1,
             source2,
             '~' AS source3,
             '' as device,
             'c' src,
             0 AS clicks,
             0 AS impressions,
             0.0 AS value,
             0.0 AS frac_contribution,
             SUM(cost) AS cost,
             0 AS tp_only,
             0 AS tp_introducer,
             0 AS tp_influencer,
             0 as tp_closer
 
             FROM
             dash_ppc_cost
             WHERE
             client = 'qvc'
             
             
             AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
             AND cost > 0 -- there are 0 cost rows reported- we dont need these.
 
 
             GROUP BY
             1, 2, 3, 4, 5, 6, 7, 8, 9, 10
               -----------------------------------------------------------
     
     ) q1
 ) q2
 Where (src='r' or src_cnt = 1)  -- catch rows where cost but no rev
 
 
 
    ) q1 ) q1 where trim(device) <> 'unknown' ) AS SRC GROUP BY 1  ORDER BY 1     LIMIT 10001 ;






SELECT /*+label(zvika_cross_channel_chart)*/ source1 AS source1,
                                       SUM(clicks)::INT AS clicks,
                                       SUM(value)::FLOAT AS value,
                                       SUM(frac_contribution)::FLOAT AS frac_contribution,
                                       SUM(cost)::FLOAT AS cost,
                                       SUM(clicks_past)::INT AS clicks_past,
                                       SUM(value_past)::FLOAT AS value_past,
                                       SUM(frac_contribution_past)::FLOAT AS frac_contribution_past,
                                       SUM(cost_past)::FLOAT AS cost_past,
                                       SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click,
                                                           SUM(VALUE_past)::FLOAT / SUM(clicks_past)::INT AS revenue_per_click_past
FROM
  (SELECT /*+label(zvika_cross_channel_chart)*/ '~' AS DATE,
                                          site_name,
                                          source1,
                                          SUM(clicks) AS clicks,
                                          SUM(impressions) AS impressions,
                                          SUM(VALUE) AS VALUE,
                                          SUM(frac_contribution) AS frac_contribution,
                                          SUM(cost) AS cost,
                                          SUM(clicks_past) AS clicks_past,
                                          SUM(impressions_past) AS impressions_past,
                                          SUM(VALUE_past) AS value_past,
                                          SUM(frac_contribution_past) AS frac_contribution_past,
                                          SUM(cost_past) AS cost_past
   FROM
     (SELECT model, DATE, v_site_id AS site_id,
                          v_site_name AS site_name,
                          source1,
                          SUM(impressions) AS impressions,
                          SUM(clicks) AS clicks,
                          SUM(VALUE) AS VALUE,
                          SUM(frac_contribution) AS frac_contribution,
                          0.0 AS cost,
                          0 AS impressions_past,
                          0 AS clicks_past,
                          0.0 AS VALUE_past,
                          0.0 AS frac_contribution_past,
                          0.0 AS cost_past
      FROM exp_dash_performance_optimization
      WHERE client = 'qvc' -- whitelist filter
AND DATE BETWEEN '2014-12-01' AND '2015-02-28'
        AND event_type NOT IN ('all events') -- site names            -- event filters
AND model IN ('Regression',
              '-') -- model filters

      GROUP BY 1,
               2,
               3,
               4,
               5
      UNION ALL SELECT '' model, DATE, site_id,
                                       site_name,
                                       source1,
                                       0 AS impressions,
                                       0 AS clicks,
                                       0.0 AS VALUE,
                                       0.0 AS frac_contribution,
                                       SUM(cost) AS cost,
                                       0 AS impressions_past,
                                       0 AS clicks_past,
                                       0.0 AS VALUE_past,
                                       0.0 AS frac_contribution_past,
                                       0.0 AS cost_past
      FROM dash_ppc_cost
      WHERE client = 'qvc'
        AND DATE BETWEEN '2014-12-01' AND '2015-02-28' -- site names

      GROUP BY 1,
               2,
               3,
               4,
               5 HAVING SUM(cost) > 0
      UNION ALL SELECT model, ('2014-12-01'::DATE- '08/25/2014'::DATE) + DATE AS DATE,
                                                                         v_site_id AS site_id,
                                                                         v_site_name AS site_name,
                                                                         source1,
                                                                         0 AS impressions,
                                                                         0 AS clicks,
                                                                         0.0 AS VALUE,
                                                                         0.0 AS frac_contribution,
                                                                         0.0 AS cost,
                                                                         SUM(impressions) AS impressions_past,
                                                                         SUM(clicks) AS clicks_past,
                                                                         SUM(VALUE) AS VALUE_past,
                                                                         SUM(frac_contribution) AS frac_contribution_past,
                                                                         0.0 AS cost_past
      FROM exp_dash_performance_optimization
      WHERE client = 'qvc' -- whitelist filter
AND DATE BETWEEN '08/25/2014' AND '11/22/2014'
        AND event_type NOT IN ('all events') -- site names            -- event filters
AND model IN ('Regression',
              '-') -- model filters

      GROUP BY 1,
               2,
               3,
               4,
               5
      UNION ALL SELECT '' model, ('2014-12-01'::DATE- '08/25/2014'::DATE) + DATE AS DATE,
                                                                            site_id,
                                                                            site_name,
                                                                            source1,
                                                                            0 AS impressions,
                                                                            0 AS clicks,
                                                                            0.0 AS VALUE,
                                                                            0.0 AS frac_contribution,
                                                                            0.0 AS cost,
                                                                            0 AS impressions_past,
                                                                            0 AS clicks_past,
                                                                            0.0 AS VALUE_past,
                                                                            0.0 AS frac_contribution_past,
                                                                            SUM(cost) AS cost_past
      FROM dash_ppc_cost
      WHERE client = 'qvc'
        AND DATE BETWEEN '08/25/2014' AND '11/22/2014' -- site names

      GROUP BY 1,
               2,
               3,
               4,
               5 HAVING SUM(cost) > 0) q1
   GROUP BY 1,
            2,
            3) AS SRC
GROUP BY 1
ORDER BY value DESC LIMIT 10001 ;








