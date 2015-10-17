alias m 'more'


#unalias rm

alias del 'rm -i'

alias rd 'rm -r'

alias lm 'ls -t | less'

alias lt 'ls -ltr '

unalias ls

alias lth 'ls -ltrh '

alias pp 'ps -ef | grep -v grep | grep '

#alias showswap 'swapinfo -m;vmstat -s | head -4'

alias showswap 'vmstat -s | head -4'

alias showusage 'du -k  | sort -rn | head -10'

#alias topmem 'ps -auxww | head -1;ps -auxww | grep -v ^USER | sort -rk4 | head -20' # fix top command

#alias topcpu 'ps -auxwww | head -1;ps -auxww | grep -v ^USER | sort -rk3 |head -20' # fix top command

alias topcpu '/usr/ucb/ps -auxw | head -1;/usr/ucb/ps -auxw | grep -v ^USER | sort -rk3 |head -20'

alias topmem '/usr/ucb/ps -auxw | head -1;/usr/ucb/ps -auxw | grep -v ^USER | sort -rk4 |head -20'

alias meminfo 'prtconf | head -2 | tail -1;swap -s'

alias h 'history'

alias cls 'clear'

alias cdz 'cd ${HOME}/'

alias cdsql 'cd ${HOME}/Sql/'

alias cdlog 'cd ${HOME}/Log/'

alias cddmp 'cd ${HOME}/Dmp/'

alias cdtemp 'cd ${HOME}/Temp/'

alias cdtmp 'cd ${HOME}/Temp/'

alias cdscript 'cd ${HOME}/Scripts/'

alias cdscripts 'cd ${HOME}/Scripts/'

alias lstotal 'ls -lt | awk '\'\{'total +  $5}; END {echo total/1024/1024 " MG "}'\'


unalias ls

unalias vi

alias ver 'cat /etc/*-release'


# Vertica section

alias cdalert 'cd /lpbi/catalog/lpbi/v_lpbi_node0005_catalog/; ls -ltrh vertica.log'

alias cdoem 'cd /home/oracle/11g/sql_oem; ls -ltrh '

alias q '${SQL}/run_sql.ksh '

alias qq '${SQL}/run_sql1.ksh '

alias ql '${SQL}/run_sql_loop.ksh '

alias qs '${SQL}/run_sql_noecho.ksh '



alias stg 'source ${HOME}/stg'

alias prod 'source ${HOME}/prod'

alias prod_dr 'source ${HOME}/prod_dr'

alias uk 'source ${HOME}/uk'

alias uk_dr 'source ${HOME}/uk_dr'

alias alpha 'source ${HOME}/alpha'

alias stg_new 'source ${HOME}/stg_new'

