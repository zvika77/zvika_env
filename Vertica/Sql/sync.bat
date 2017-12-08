@echo off
setlocal EnableDelayedExpansion

if "%1" == "" goto Usage


IF "%2" == "" (
set "file_filter=*"
) ELSE (
set "file_filter=%2"
)


if "%INFOPASS%" == "" (
	echo INFOPASS is not set
	goto Exit
)



set "source=%1"
set "startdir=%cd%"
set "cname=%computername%"


if "%~1" == "list" (
	
	echo ===========================================
	echo .
	type %startdir%\sync_target.txt
	echo .
	echo ===========================================
	goto Exit
)

echo ================================
echo Source       :   %source% 
echo Filter	  :    %file_filter%
echo ================================


pause

REM  get the master 

for /f "tokens=1-4" %%a in ('type %startdir%\sync_target.txt') do (
if "%%d" == "master" (
	set master_user=%%a
	set master_host=%%b
	set master_dir=%%c
	
)
)


echo "Master: !master_user!@!master_host!:!master_dir!"



REM chcking if the source is the master (the script initiator) if yes bring the changes to the master from the source

for /f "tokens=1-3" %%a in ('type %startdir%\sync_target.txt') do (

if "%%b" == "!source!" (

	if /I  NOT "%source%" == "!master_host!" (

		REM set "scp_source=%%a@%%b:%%c%file_filter%"
		echo "Coyping source to master [!master_host!]..."
		pscp -unsafe -2 -pw "!INFOPASS!"  %%a@%%b:%%c%file_filter% %master_dir% 

	)
)
)



if "%source%" == "" (
	echo Scp source not Found !!! 
	echo Run list to get sources
	goto Exit
)

REM copy from master to all targets

for /f "tokens=1-3" %%a in ('type %startdir%\sync_target.txt') do (
REM		echo %%a " aaaa " %source%
	if NOT "%%b" == "%source%" (
		if NOT "%%b" == "%master_host%" (
		 echo "Now syncing %%b ..."
REM		 echo "scp %master_dir%%file_filter% %%a@%%b:%%c"
		 pscp -unsafe -2 -pw "!INFOPASS!" %master_dir%%file_filter% %%a@%%b:%%c
		)
	)	
)

goto Exit


:Usage

echo -----------------------------------------------------------
echo .
echo Usage: %~n0 ^< source ^|  list ^> ^< filter [*] ^>
echo Example: sync STM20 *.sql
echo .
echo -----------------------------------------------------------


goto Exit





:Exit

endlocal
