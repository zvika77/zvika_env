\timing 
SELECT /*+label(zvika1dash_geo)*/ country_code AS country, region AS region, dma_code AS dma, SUM(clicks)::INT AS clicks, SUM(value)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(frac_contribution)::FLOAT / SUM(clicks)::INT AS conversion_rate, SUM(cost)::FLOAT AS cost, SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click FROM ( select country_code, region, dma_code, SUM(clicks)::INT AS clicks, SUM(value)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, sum(cost)::FLOAT AS cost from ( select /*+label(dash_geo)*/ dt as date, v_site_id as site_id, v_site_name as site_name, source1, source2, source3, country_code, region, city, dma_code, cost_by_s123 * (decode(cnt, 0 ,1 ,grp_cnt/cnt)) as cost, -- case stmt: if event row exists with no hit/click data.
clicks,
impressions,
frac_contribution,
rev as value

from
(
  select
  src,
  dt,
  v_site_id,
  v_site_name,
  source1,
  source2,
  source3,
  country_code,
  region,
  city,
  dma_code,
  clicks,
  impressions,
  frac_contribution,
  rev,
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
              sum(impressions) as impressions,
              sum(clicks) as clicks,
              sum(value) as rev,
              SUM(frac_contribution) AS frac_contribution,
              0.0 AS cost
          FROM
              dash_performance_optimization
          WHERE
              client = 'intuit'
                   -- whitelist filter
            AND DATE BETWEEN '2014-02-23' AND '2014-04-15'
            AND event_type NOT IN ('all events')
            AND NOT (provider = 'offline_sources' AND impressions > 0 AND country_code is null )
            AND v_site_name IN ('TurboTax')  -- site names
             -- event filters
            AND model IN ('Regression','-') -- model filters

          GROUP BY
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
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
          '' dma_code,
          '' city,
          'c' src,
          0 AS clicks,
          0 AS impressions,
          0.0 AS value,
          0.0 AS frac_contribution,
          SUM(cost) AS cost
        FROM
          dash_ppc_cost
        WHERE
        client = 'intuit'
        
        
        AND site_name IN ('TurboTax')  -- site names
        AND DATE BETWEEN '2014-02-23' AND '2014-04-15'
        AND cost > 0 -- there are 0 cost rows reported- we dont need these.
        AND provider not in ('offline_sources', 'tv', 'radio')
          -- site names
        GROUP BY
         1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
            -----------------------------------------------------------

  ) q1
) q2

Where (src='r' or src_cnt = 1)  -- catch rows where cost but no rev





  ) q1
group by 1,2,3

) AS SRC
GROUP BY 1,2,3
 ORDER BY value DESC 



 LIMIT 10001 ;
 
 
 
 SELECT /*+label(zvika1dash_device_chart_cost)*/ device AS device, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(clicks)::INT AS clicks FROM ( select /*+label(dash_device_chart_cost)*/ date, source1, device, frac_contribution, value, cost, clicks from ( select *, sum(value) over(partition by source1) as totalvalue, sum(cost) over() as totalcost from ( select /*+label(dash_device_cost)*/ dt as date, v_site_id as site_id, v_site_name as site_name, source1, source2, source3, decode(device,'','unknown',device) as device, cost_by_s123 * (decode(cnt, 0 ,1 ,grp_cnt/cnt)) as cost, -- case stmt: if event row exists with no hit/click data.
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
            dash_performance_optimization
            WHERE
            client = 'intuit'
                 -- whitelist filter
            AND DATE BETWEEN '2013-12-01' AND '2014-04-15'
            AND event_type NOT IN ('all events')
            AND v_site_name IN ('TurboTax')  -- site names
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
            client = 'intuit'
            
            
            AND DATE BETWEEN '2013-12-01' AND '2014-04-15'
            AND cost > 0 -- there are 0 cost rows reported- we dont need these.


            GROUP BY
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10
              -----------------------------------------------------------
    
    ) q1
) q2
Where (src='r' or src_cnt = 1)  -- catch rows where cost but no rev




  ) q1
) q1
where trim(device) <> 'unknown'
and totalvalue::FLOAT > 1000
and ((totalcost > 0 and cost > 0) or totalcost = 0) -- if client doesnt have cost, trigger the cost warning
) AS SRC
GROUP BY 1
 ORDER BY 1



 LIMIT 10001 ;
 
 
 SELECT /*+label(zvika1cross_channel_perf)*/ source1 AS source1, SUM(value)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click, SUM(cost)::FLOAT AS cost, SUM(VALUE)::FLOAT / SUM(clicks)::INT AS revenue_per_click FROM ( SELECT /*+label(cross_channel_perf)*/ '~' AS DATE, '~' AS site_name, source1 AS source1, '~' AS source2, '~' AS source3, SUM(clicks) AS clicks, SUM(impressions) AS impressions, SUM(VALUE) AS VALUE, SUM(frac_contribution) AS frac_contribution, SUM(tp_only) AS tp_only, SUM(tp_introducer) AS tp_introducer, SUM(tp_influencer) AS tp_influencer, SUM(tp_closer) as tp_closer, SUM(cost) AS cost FROM ( SELECT model, DATE, v_site_id as site_id, v_site_name AS site_name, source1, source2, '~' AS source3, SUM(impressions) AS impressions, SUM(clicks) AS clicks, SUM(VALUE) AS VALUE, SUM(frac_contribution) AS frac_contribution, SUM(tp_only) AS tp_only, SUM(tp_introducer) AS tp_introducer, SUM(tp_influencer) AS tp_influencer, SUM(tp_closer) as tp_closer, 0.0 AS cost FROM dash_performance_optimization WHERE client = 'intuit' -- whitelist filter
          AND DATE BETWEEN '2013-12-01' AND '2014-04-15'
          AND event_type NOT IN ('all events')
          AND v_site_name IN ('TurboTax')  -- site names
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
          client = 'intuit'
          
          
          AND DATE BETWEEN '2013-12-01' AND '2014-04-15'
          AND site_name IN ('TurboTax')  -- site names
        GROUP BY 
          1, 2, 3, 4, 5, 6, 7
        HAVING SUM(cost) > 0
) q1
GROUP BY 
  1,2,3,4,5


) AS SRC
GROUP BY 1
 ORDER BY 1



 LIMIT 10001 ;
 
 
 
 
 SELECT /*+label(zvika1dash_display_report_chart_cost)*/ SUM(cost)::FLOAT AS cost, SUM(clicks)::INT AS clicks, SUM(VALUE)::FLOAT AS value, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(clicks_past)::INT AS clicks_past, SUM(value_past)::FLOAT AS value_past, SUM(frac_contribution_past)::FLOAT AS frac_contribution_past, SUM(cost_past)::FLOAT AS cost_past FROM ( SELECT /*+label(dash_display_report_chart_cost)*/ date, network, cost, value, clicks, frac_contribution, 0.0 as cost_past, 0.0 as value_past, 0 as clicks_past, 0 as frac_contribution_past from ( SELECT *, sum(cost) over (partition by network) as network_cost, sum(cost) over () as total_cost from ( -------------------------------------------------
SELECT
/*+label(dash_display_report)*/ DATE, network, SUM(cost) AS cost, SUM(VALUE) AS VALUE, SUM(clicks) AS clicks, SUM(frac_contribution) AS frac_contribution from ( --------------------------------------------------
		SELECT
		DATE,
    network, -- - sort this out.  use cost first
		creative,
    max(type) as type,
		SUM(cost) AS cost,
		SUM(VALUE) AS VALUE,
		SUM(clicks) AS clicks,
		SUM(impressions) AS impressions,
		SUM(frac_contribution) AS frac_contribution

		from(
				select
				DATE,
        source1,
        source2,
        source3,
        matchtype as type,
				max(provider) as network,
				max(kw_from_feed) as creative,
				0 AS clicks,
				0 AS impressions,
				SUM(cost) AS cost,
				0.0 AS VALUE,
				0.0 AS frac_contribution
				FROM
        dash_ppc_cost
				WHERE
				client = 'intuit'
        and regexp_like(source1, '(disp$)|(displ)|(ros$)|(addro)|(^(?!ppc).*reta?r?g)|(cvort)|(banner)|(m6$)|(simplifi)|(aol)|(rema?rk)|(dataprovid)', 'i')
        
        
				AND DATE BETWEEN '12/01/2013' AND '04/15/2014'
				-- AND cost > 0 -- there are 0 cost rows reported- we dont need these.
				AND site_name IN ('TurboTax')  -- site names
				GROUP BY
				1,2,3,4,5



			  UNION ALL


				SELECT
				DATE,
			  source1,
        source2,
        source3,
        max(channel) as type,
        max(provider) as network,
        max(opt1) as creative,

				SUM(clicks) AS clicks,
				SUM(impressions) AS impressions,
				0.0 AS cost,
				SUM(VALUE) AS VALUE,
				SUM(frac_contribution) AS frac_contribution
				FROM
				exp_dash_performance_optimization
				WHERE
				client = 'intuit'
             -- whitelist filter
        and channel in  ('display', 'retargeting')
				AND DATE BETWEEN '12/01/2013' AND '04/15/2014'
				AND v_site_name IN ('TurboTax')  -- site names
				 -- event filters
				AND model IN ('Regression','-') -- model filters
				GROUP BY
				1,2,3,4



		) q1
		GROUP BY
		1,2,3


) q1
GROUP BY
1,2





  ) q1
) q2
where network_cost > 0 or total_cost = 0


union all


SELECT
  '12/01/2013'::DATE - '06/30/2013'::DATE + date as date,
  network,
  0.0 as cost,
  0.0 as value,
  0 as clicks,
  0 as frac_contribution,
  cost as cost_past,
  value as value_past,
  clicks as clicks_past,
  frac_contribution as frac_contribution_past



  from (
  SELECT *,
  sum(cost) over (partition by network) as network_cost,
  sum(cost) over () as total_cost from  (
    


-------------------------------------------------
SELECT
/*+label(zvika1dash_display_report)*/ DATE, network, SUM(cost) AS cost, SUM(VALUE) AS VALUE, SUM(clicks) AS clicks, SUM(frac_contribution) AS frac_contribution from ( --------------------------------------------------
		SELECT
		DATE,
    network, -- - sort this out.  use cost first
		creative,
    max(type) as type,
		SUM(cost) AS cost,
		SUM(VALUE) AS VALUE,
		SUM(clicks) AS clicks,
		SUM(impressions) AS impressions,
		SUM(frac_contribution) AS frac_contribution

		from(
				select
				DATE,
        source1,
        source2,
        source3,
        matchtype as type,
				max(provider) as network,
				max(kw_from_feed) as creative,
				0 AS clicks,
				0 AS impressions,
				SUM(cost) AS cost,
				0.0 AS VALUE,
				0.0 AS frac_contribution
				FROM
        dash_ppc_cost
				WHERE
				client = 'intuit'
        and regexp_like(source1, '(disp$)|(displ)|(ros$)|(addro)|(^(?!ppc).*reta?r?g)|(cvort)|(banner)|(m6$)|(simplifi)|(aol)|(rema?rk)|(dataprovid)', 'i')
        
        
				AND DATE BETWEEN '06/30/2013' AND '11/12/2013'
				-- AND cost > 0 -- there are 0 cost rows reported- we dont need these.
				AND site_name IN ('TurboTax')  -- site names
				GROUP BY
				1,2,3,4,5



			  UNION ALL


				SELECT
				DATE,
			  source1,
        source2,
        source3,
        max(channel) as type,
        max(provider) as network,
        max(opt1) as creative,

				SUM(clicks) AS clicks,
				SUM(impressions) AS impressions,
				0.0 AS cost,
				SUM(VALUE) AS VALUE,
				SUM(frac_contribution) AS frac_contribution
				FROM
				exp_dash_performance_optimization
				WHERE
				client = 'intuit'
             -- whitelist filter
        and channel in  ('display', 'retargeting')
				AND DATE BETWEEN '06/30/2013' AND '11/12/2013'
				AND v_site_name IN ('TurboTax')  -- site names
				 -- event filters
				AND model IN ('Regression','-') -- model filters
				GROUP BY
				1,2,3,4



		) q1
		GROUP BY
		1,2,3


) q1
GROUP BY
1,2





  ) q1
) q2
where network_cost > 0 or total_cost = 0



) AS SRC



 LIMIT 10001 ;
 
 
 
 
 SELECT /*+label(zvika1affiliate_report_chart_cost)*/ affiliate AS affiliate, pub_id AS pub_id, SUM(frac_contribution)::FLOAT AS frac_contribution, SUM(value)::FLOAT AS value, SUM(value_last)::FLOAT AS value_last, SUM(value_regression)::FLOAT AS value_regression, SUM(cost)::FLOAT AS cost FROM ( select /*+label(affiliate_report_chart_cost)*/ DATE, affiliate, pub_id, frac_contribution, value, value_last, value_regression, cost from ( select *, sum(value) over(partition by affiliate) as totalvalue, sum(cost) over() as totalcost from ( SELECT /*+label(dash_affiliate_report)*/ '~' AS DATE, '~' AS site_name, affiliate AS affiliate, pub_id AS pub_id, SUM(clicks) AS clicks, SUM(VALUE) AS VALUE, SUM(frac_contribution) AS frac_contribution, SUM(tp_only) AS tp_only, SUM(tp_introducer) AS tp_introducer, SUM(tp_influencer) AS tp_influencer, SUM(tp_closer) as tp_closer, sum(value_last) as value_last, sum(value_regression) as value_regression, SUM(cost) AS cost FROM( SELECT date, v_site_name, affiliate, decode(max(pub_id) over (partition by affiliate, opt1), '', opt1, max(pub_id) over (partition by affiliate, opt1)) as pub_id, clicks, value, frac_contribution, tp_only, tp_introducer, tp_influencer, tp_closer, value_last, value_regression, cost FROM ( SELECT date, v_site_name, affiliate, opt1, max(pub_id) as pub_id, sum(clicks) as clicks, sum(value) as value, sum(frac_contribution) as frac_contribution, sum(tp_only) as tp_only, sum(tp_introducer) as tp_introducer, sum(tp_influencer) as tp_influencer, sum(tp_closer) as tp_closer, sum(value_last) as value_last, sum(value_regression) as value_regression, sum(cost) as cost FROM ( ------------------------------------------------------------------------

                SELECT
                client,
                model,
                date,
                v_site_id,
                v_site_name,
                channel,  --
                provider as affiliate,
                opt1,
                '' as pub_id,
                sum(decode(model,'-', clicks, 0)) as clicks,
                sum(decode(model,'Regression', value, 0)) as value,
                sum(decode(model,'Regression', frac_contribution, 0)) as frac_contribution,
                sum(decode(model,'Regression', tp_only, 0)) as tp_only,
                sum(decode(model,'Regression', tp_introducer, 0)) as tp_introducer,
                sum(decode(model,'Regression', tp_influencer, 0)) as tp_influencer,
                sum(decode(model,'Regression', tp_closer, 0)) as tp_closer,
                sum(decode(model,'Last Click (Referrer)', value, 0)) as value_last,
                sum(decode(model,'Regression', value, 0)) as value_regression,
                0 as cost
                FROM
                dash_performance_optimization
                WHERE
                client = 'intuit'
                and source1 ilike '%affil%'
                     -- whitelist filter
                AND DATE BETWEEN '2013-12-01' AND '2014-04-15'
                AND v_site_name IN ('TurboTax')  -- site names
                 -- event filters
                AND ( model IN ('-','Regression', 'Last Click (Referrer)') or model = 'Regression') -- model filters

                GROUP BY
                1, 2, 3, 4, 5, 6, 7, 8, 9

                -----------------------------------------------------------
                union all
                -----------------------------------------------------------
                select
                client,
                model,
                date,
                v_site_id,
                v_site_name,
                channel,
                affiliate,
                decode(client, '1800flowers', source2, source3) as opt1,
                pub_id,
                0 AS clicks,
                0.0 AS value,
                0.0 AS frac_contribution,
                0 as tp_only,
                0 as tp_introducer,
                0 as tp_influencer,
                0 as tp_closer,
                0.0 as value_last,
                0.0 as value_regression,
                sum(cost) as cost
                from (

                  select
                  client,
                  '' as model,
                  date,
                  site_id as v_site_id,
                  site_name as v_site_name,
                  source1 as channel,
                  source2,
                  source3,
                  matchtype,
                  provider as affiliate,
                  kw_from_feed as pub_id,
                  SUM(cost) AS cost
                  FROM
                    dash_ppc_cost
                      WHERE
                      client = 'intuit'
                      
                      
                      AND DATE BETWEEN '2013-12-01' AND '2014-04-15'
                      -- AND cost > 0 -- there are 0 cost rows reported- we dont need these.
                      AND source1 = 'affiliate'
                      AND site_name IN ('TurboTax')
                  GROUP BY
                  1,2,3,4,5,6,7,8, 9, 10,11
                ) q_cost_inner group by 1,2,3,4,5,6,7,8,9

                -----------------------------------------------------------

        ) q1 GROUP BY 1,2,3,4
    ) q2
) q3 GROUP BY 1,2,3,4




  ) q1
) q2
where
 totalvalue::FLOAT >= 1000
 and
trim(affiliate) <> 'unknown'
and trim(pub_id) <> 'unknown'
and ((totalcost > 0 and cost > 0) or totalcost = 0) -- if client doesnt have cost, trigger the cost warning


) AS SRC
GROUP BY 1,2
 ORDER BY 1,2



 LIMIT 10001 ;
 
 
\o
