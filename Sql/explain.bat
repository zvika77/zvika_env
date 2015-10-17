@echo off
setlocal


set "script_full_path=%1"

echo =======================
echo "script  => %script_full_path% "
echo =======================
 
awk "/QUERY PLAN DESCRIPTION/,/GraphViz Format/"  %script_full_path% 


REM type %script_full_path%

REM Echo "Prerparing Explain for Graphvis ...."

awk "/digraph G/,/}/"  %script_full_path% >  %script_full_path%.pln

REM Echo "Processing Graph ...."

dot %script_full_path%.pln -Tsvg -o %script_full_path%.html

REM Echo "Done. Opening ..."

cmd /C  start firefox %script_full_path%.html

rm %script_full_path%.pln
rm %script_full_path%