@echo off
setlocal

if "%1" == "" goto Usage

if "%INFOPASS%" == "" (
	echo INFOPASS is not set
	goto Exit
)


if "%~1" == "prod" (
	call :Get colo   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get uk   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get smblp3   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get uklp1    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get poltp    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get soltp    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	goto Exit
)
 if "%~1" == "dr" (
	call :Get prod_dr   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get uk_dr   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get smbwhlp3   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get whuklp1    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get pwh
REM	call :Get swh
	goto Exit
 )
 if "%~1" == "alpha" (
	call :Get alpha "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get dwh    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	goto Exit
 )
 if "%~1" == "all" (
	call :Get colo "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get prod_dr "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get uk "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get uk_dr "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get alpha "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	call :Get stg "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
	goto Exit
 )
REM if "%~1" == "bana" (
REM	call :Get boalp3    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get whboalp3  "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	goto Exit
REM )
REM if "%~1" == "ent" (
REM	call :Get entlp3     "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get entwhlp3   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	goto Exit
REM )
REM if "%~1" == "smb" (
REM	call :Get smblp3     "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get smbwhlp3   "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	goto Exit
REM )
REM if "%~1" == "uk" (
REM	call :Get uklp1      "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get whuklp1    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	goto Exit
REM )
REM if "%~1" == "bi" (
REM	call :Get dwrep  "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM REM	call :Get dwh    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	goto Exit
REM )
REM if "%~1" == "bill" (
REM	call :Get bccdb_prod  "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get rbmdb_prod    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	call :Get trsdb_prod    "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
REM	goto Exit
REM )
call :Get "%1" "%2" "%%3"  "%%4" "%%5" "%%6" "%%7"
goto Exit

:Get
		 
		 start "%1" conn %1  %2 %3 %4 
goto :EOF

:Usage
echo Usage: %~n0 ^< make ^| check ^| list ^| machine ^| group ^>
echo .
echo        GROUPS :  prod , dr , all
echo -----------------------------------------------------------

goto Exit

:Exit

endlocal

