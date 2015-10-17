@echo off


set script=%1
set param1=%2
set param2=%3
set param3=%4
set param4=%5


echo =======================
echo Script %script%
echo Param1 %param1%
echo Param2 %param2%
echo Param3 %param3%
echo Param4 %param4%
echo =======================



REM echo vsql -h %V_DB%  -U %V_USER% -w %V_PASS% -a  --echo-all  -v 1='%param1%' -v 2='%param2%' -v 3='%param3%' -v 4='%param4%'  -f %script%
vsql -h %V_DB%  -U %V_USER% -w %V_PASS% -a  --echo-all  -v 1='%param1%' -v 2='%param2%' -v 3='%param3%' -v 4='%param4%'  -f %script%
