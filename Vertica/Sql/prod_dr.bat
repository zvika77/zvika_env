@echo off


cls
set V_DB=ropr-dbv05
set V_USER=vertica


set PWDSCR=%~d0%~p0getpwd.vbs
if not exist %PWDSCR% (
        echo Password script %PWDSCR% does not exist
        goto Exit
)

set /p V_PASS=Password:<nul
for /f "delims=" %%i in ('cscript /nologo %PWDSCR%') do set V_PASS=%%i
echo.

:Exit

doskey q=run_sql.bat %1 $1 $2 $3 $4 %$ 
doskey qq=run_sql1.bat 
doskey qs=run_sql_noecho.bat %1 $1 $2 $3 $4 %$ 

title %V_USER%@%V_DB%

echo =======================
echo V_DB %V_DB%
echo V_USER %V_USER%
echo =======================

