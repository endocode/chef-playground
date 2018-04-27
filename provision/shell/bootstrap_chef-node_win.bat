@echo off

SET NEWLINE=^& echo.


set SOURCE_PATH=%1
set MOUNT_PATH=%2
set CHEF_SERVER_IP=%3

:: importing configuration variables
call %SOURCE_PATH%\conf.env.bat


set CHEF_CONF_DIR=C:\chef
set ETC_HOSTS=%WINDIR%\system32\drivers\etc\hosts
set CHEF_CLIENT_INSTALL_MSI_URL=https://packages.chef.io/files/stable/chef/%CHEF_CLIENT_VERSION%/windows/2012/chef-client-%CHEF_CLIENT_VERSION%-1-x64.msi

set INSTALLER_CONFIG=ChefClientFeature,ChefPSModuleFeature
if "%DAEMONIZE_CHEF_CLIENT%" == "true" (
    INSTALLER_CONFIG=%INSTALLER_CONFIG%,ChefServiceFeature
)



:: NOTE: required because when using the script in this context (vagrant, provisioning, batch), the
:: cmd env does not respect the changed PATH var by chocolaty
PATH=%PATH%;C:\ProgramData\chocolatey\bin



set CHEF_CLIENT_INSTALL_MSI_PATH=%TEMP%\chef-client-%CHEF_CLIENT_VERSION%.msi
curl --output %CHEF_CLIENT_INSTALL_MSI_PATH% --location --silent %CHEF_CLIENT_INSTALL_MSI_URL%


msiexec /qn /i %CHEF_CLIENT_INSTALL_MSI_PATH% ADDLOCAL=%INSTALLER_CONFIG%


mkdir "%CHEF_CONF_DIR%"
copy "%SOURCE_PATH%\conf.env" "%CHEF_CONF_DIR%\" /y
copy "%SOURCE_PATH%\client.rb" "%CHEF_CONF_DIR%\\client.rb" /y
copy "%MOUNT_PATH%\chef-server-tls.crt" "%CHEF_CONF_DIR%\" /y
copy "%MOUNT_PATH%\%ORGA_NAME%_org.key" "%CHEF_CONF_DIR%\" /y

@echo on
FIND /C /I "%CHEF_SERVER_NAME%" %ETC_HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^%CHEF_SERVER_IP% %CHEF_SERVER_NAME%>>%ETC_HOSTS%
@echo off

C:\opscode\chef\bin\chef-client --once
