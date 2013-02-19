@ECHO OFF
SETLOCAL

set eth="xxx"   rem your Ethernet card name



FOR /F "DELIMS=" %%A IN ('ipconfig /all ^| find "Subnet Mask"') DO SET sMask=%%A
FOR  %%A IN (%sMask%) DO SET mask=%%A

FOR /F "DELIMS=" %%A IN ('ipconfig /all ^| find "Default Gateway"') DO SET sGateway=%%A
FOR  %%A IN (%sGateway%) DO SET gateway=%%A

set a=1
call :main
goto :eof

:main
set /p input="press any key to contine,'q' to exit:"
if "%input%"=="q" (set a=3) else (call :ChangeIP)
if %a% lss 2 (call :main) 
goto :eof


:ChangeIP
FOR /F "DELIMS=" %%A IN ('ipconfig /all ^| find "IP Address"') DO SET sIp=%%A
FOR  %%A IN (%sIp%) DO SET ip=%%A

FOR /F "tokens=1-4 DELIMS=." %%a IN ("%ip%") do ( set last=%%d & set first=%%a.%%b.%%c.)

set /a last+=1
if %last% EQU 255 set last=1

set nextIP=%first%%last%
echo.
echo changing current ip to£º[%nextIP%] [%mask%] [%gateway%]

netsh interface ip set address name=%eth% source=static addr=%nextIP% mask=%mask% gateway=%gateway% gwmetric=auto 

echo ---------------------------------

echo  change finished 

echo ---------------------------------
echo.           
goto :eof

ENDLOCAL

