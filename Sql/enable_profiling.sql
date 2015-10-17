--enable profile for one node only and only this session
SELECT SHOW_PROFILING_CONFIG();

SELECT ENABLE_PROFILING(:1) ;
