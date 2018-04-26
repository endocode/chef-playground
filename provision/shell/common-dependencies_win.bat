@echo off


set SOURCE_PATH=%1
set MOUNT_PATH=%2
set CHEF_SERVER_IP=%3


:: NOTE: required because when using the script in this context (vagrant, provisioning, batch), the
:: cmd env does not respect the changed PATH var by chocolaty
PATH=%PATH%;C:\ProgramData\chocolatey\bin


choco install -y curl

:: Disable firewall
netsh advfirewall set privateprofile state off

:: Disable automatic updates
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 0 /f
sc config wuauserv start= disabled
net stop wuauserv