-- filter example : 2018-01-22\ 12:08
WITH 
 generate_dt_series AS
  (select n ,:2::timestamp - (n * interval '1 second')AS dt from
(select row_number() over () AS n
,datediff(SECONDS,:1::timestamp , :2::timestamp) sec
from stl_scan ) a
where n <=  sec)
select dt,max(cont) cont ,pid as pid , max(dur_sec) as dur_sec,trim(usename) username,max(starttime) starttime,max(endtime) endtime, max(text) text
from (
  SELECT count(pid) over (partition by dt) as cont,*
  FROM generate_dt_series gds
    LEFT OUTER JOIN (SELECT userid,
                       pid,
                       datediff(SECONDS, starttime, endtime) AS dur_sec,
                       starttime,
                       endtime,
                       substring(text,1,50) text
                     FROM SVL_STATEMENTTEXT
                     WHERE sequence = 0) sst
      ON (gds.dt BETWEEN sst.starttime AND sst.endtime)
) details left join pg_user_info pui on (details.userid = pui.usesysid)
group by dt,pid,usename
order by dt,pid 