--clear profile info from system tables 


select clear_profiling(:1, 'local');
select clear_profiling(:1, 'global');
