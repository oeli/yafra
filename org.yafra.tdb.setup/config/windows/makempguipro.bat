@ echo off
if  {%1}=={} goto help

REM
REM make the .mpgui in path %1 with db %2 user %3 and pwd %4
REM
echo # MARCO POLO TO Classic X11/Motif GUI settings> %1
echo # generated by installer>> %1
echo 1:%2>> %1
echo 2:%3>> %1
echo 3:%4>> %1
goto end

:help
echo.
echo Syntax :
echo    makempguipro file db_name db_user db_user_password 
echo.

:end
@ echo on