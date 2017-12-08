@echo off
cls
title mypass

set PWDSCR=%~d0%~p0getpwd.vbs
if not exist %PWDSCR% (
        echo Password script %PWDSCR% does not exist
        goto Exit
)

set /p INFOPASS=Password:<nul
for /f "delims=" %%i in ('cscript /nologo %PWDSCR%') do set INFOPASS=%%i
echo.

:Exit
title %CLIENTNAME%@%COMPUTERNAME%