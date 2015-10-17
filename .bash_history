for i in {1..10}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' | wc -l; done
for i in {1..10}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' | echo " conn" wc -l; done
for i in {1..10}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' | echo " conn" | wc -l; done
for i in {1..10}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' |  wc -l; done
for i in {1..10}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' |  wc -l; sleep 5; done
for i in {1..1000}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' |  wc -l; sleep 5; done
for i in {1..1000}; do /home/zvikag/Vertica/Sql/run_sql.ksh show_session_active.sql | grep 'select site_control_group_i' |  wc -l; sleep 2; done
exit
model ENCODING AUTO,
 client ENCODING RLE,
 event_type ENCODING AUTO,
 date ENCODING RLE,
 source1 ENCODING AUTO,
 source2 ENCODING AUTO,
 source3 ENCODING AUTO,
 impressions ENCODING DELTARANGE_COMP,
 clicks ENCODING COMMONDELTA_COMP,
 value ENCODING DELTARANGE_COMP,
 frac_contribution ENCODING DELTARANGE_COMP,
 v_site_id ENCODING COMMONDELTA_COMP,
 v_site_name ENCODING RLE,
 country_code ENCODING AUTO,
 region ENCODING AUTO,
 dma_code ENCODING AUTO,
 provider ENCODING AUTO
dash
dash
dash
typescript
cd
source myaliases
cdsql
dash
q show_projections.sql public dash_performance_optimization
q show_columns_size.sql  public dash_performance_optimization
vi show_columns_size.sql 
q show_columns_size.sql  public dash_performance_optimization dash_performance_optimization_b0
q show_columns_size.sql  public dash_performance_optimization dash_performance_optimization_b0
q show_columns_size.sql  public dash_performance_optimization dash_performance_optimization_geo_b1
tail -f queries.log 
vi queries.log 
tail -f queries.log
tail -f queries.log 
lth
tail -f queries_stage.log
lth
vi queries_stage.log 
./run_stage7 
lth
vi queries_stage7.log
grep 'Time' queries_stage.log
grep 'Time' queries_stage7.log
q show_host_resources.sql %
stage
q show_host_resources.sql %
stage7
q show_host_resources.sql %
qq
stage
qqs show_host_resources.sql %
qs show_host_resources.sql %
sshdash10
sshdash10
lt
lth
cat run_stage
vi run_stage
./run_stage 3
asa
