@echo off
setlocal

echo ================================
echo Host          :   %1 
echo Script       :   %2
echo Parameter    :   %3
echo Parameter    :   %4
echo Parameter    :   %5
echo Parameter    :   %6
echo ================================

doskey q=conn.bat %1 $1 $2 $3 $4 $5 $6 $7 $8 $9 %$
doskey qs=conn1.bat %1 $1 $2 $3 $4 $5 $6 $7 $8 $9 %$
doskey ql=conn2.bat %1 $1 $2 $3 $4 $5 $6 $7 $8 $9 %$
doskey qq=conn1.bat %1 "qq"



if "%1" == "" goto Usage

if "%INFOPASS%" == "" (
	echo INFOPASS is not set
	goto Exit
)

  set ZIP=%~d0%~p0%~n0.7z
  set ZIP_ALL=%~d0%~p0%~n0_all.7z
  set TXT=%~n0.txt

 if %1 == "make" (
	
 	if not exist %TXT% (
 		echo %TXT% file not found
		goto Exit
	)

 if exist %ZIP% del %ZIP%
	if not exist %ZIP% 7z a %ZIP% %TXT% -p%INFOPASS% 2>nul
	if exist %ZIP% if exist %TXT% del %TXT%
	goto Exit
 )

 if not exist %ZIP% (
	echo %ZIP% file not found
	goto Exit
 )

 if "%~2" == "" (
 	set SQL=@z1conninst
 ) else (
 	set SQL=%~2
 )


if "%~1" == "list" (
	7z x %ZIP_ALL% -so -p%INFOPASS% 2>nul | sort
	pause
	cls
	goto Exit
)

if "%~1" == "tns" (
	%TNS_ADMIN%\tnsnames.ora
	goto Exit
)

REM echo ":Get  %1 "%2" %%3  "%%4" "%%5" "%%6" "%%7" "%%8" "%%9""

call :Get  %1 "%2" %%3  "%%4" "%%5" "%%6" "%%7" "%%8" "%%9"
goto Exit





:Get



for /f "tokens=1-3" %%a in ('7z x %ZIP% -so -p%INFOPASS% 2^>nul ^| sort') do (
	
	if "%%a" == "%~1" (
REM		 sqlplus ZVIKAG/"%%b"@%%a %SQL%    %3 %4 %5 %6
		 if "%~3" == "explain" (
			vsql -h %%b  -U ZVIKAG -w %%c  -f %SQL% -o %SQL%.out
			call  explain.bat  %SQL%.out
			) else (
REM			echo "vsql -h %%b  -U ZVIKAG -w %%c -a  --echo-all  -v 1='%3' -v 2='%4' -v 3='%5' -v 4='%6' -v 4='%7' -v 4='%8'  -f %SQL%"
			vsql -h %%b  -U ZVIKAG -w %%c -a  --echo-all  -v 1='%3' -v 2='%4' -v 3='%5' -v 4='%6' -v 5='%7' -v 6='%8' -v 7='%9' -f %SQL%
		 )
		 ) else (
		if "%~1" == "check" (
			echo Checking Database .... %%a
			echo select node_address,node_state from nodes; | vsql -U ZVIKAG -w "%%c" -h %%b>%%a.txt
			findstr "ERROR-" %%a.txt
			type %%a.txt
		)

	)
)
goto :EOF



:Usage
echo Usage: %~n0 ^< make ^| list ^| check ^|group^|sid^>
echo        groups are  prod, dr, all
goto Exit

:Exit

endlocal
