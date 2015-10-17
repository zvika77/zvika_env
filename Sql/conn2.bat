@echo off
setlocal

doskey q=conn.bat %1 $1 $2 $3 $4 %$
doskey ql=conn2.bat %1 $1 $2 $3 $4 $5 $6 $7 %$

REM echo "conn.bat %1 %2  %3 %4 %5 %6 %7 %$"


set "loop_interval=%2"
set "loop_count=%3"

 
for /l %%x in (1, 1, %loop_count%) do (
   cls
echo ========================================================
echo "Interval  => %loop_interval% Count  => %%x/%loop_count% "
echo ========================================================

REM echo %%x
   call conn %1 %4 %5 %6 %7
REM    echo "call conn2.bat %1 %2 %3 %4 %5 %6 %7 "
   sleep %loop_interval%
   
   
)

