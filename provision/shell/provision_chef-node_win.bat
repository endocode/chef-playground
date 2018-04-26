@echo off


set SOURCE_PATH=%1
set MOUNT_PATH=%2
set CHEF_SERVER_IP=%3

:: TODO does not work yet
for /f "token=*" %%x in ("%SOURCE_PATH%\conf.env") do (set "%%x")

set CHEF_CONF_DIR=C:\chef
set ETC_HOSTS=%WINDIR%\system32\drivers\etc\hosts

SET NEWLINE=^& echo.

:: NOTE: required because when using the script in this context (vagrant, provisioning, batch), the
:: cmd env does not respect the changed PATH var by chocolaty
PATH=%PATH%;C:\ProgramData\chocolatey\bin


mkdir "%CHEF_NODE_CONF_DIR%"
copy "%SOURCE_PATH%\conf.env" "%CHEF_CONF_DIR%\" /y
copy "%SOURCE_PATH%\client.rb" "%CHEF_CONF_DIR%\" /y
copy "%MOUNT_PATH%\chef-server-tls.crt" "%CHEF_CONF_DIR%\" /y
copy "%MOUNT_PATH%\%ORGA_NAME%_org.key" "%CHEF_CONF_DIR%\" /y

FIND /C /I "%CHEF_SERVER_NAME%" %ETC_HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^%CHEF_SERVER_IP% %CHEF_SERVER_NAME%>>%ETC_HOSTS%