@echo off


set SOURCE_PATH=%1
set MOUNT_PATH=%2
set CHEF_SERVER_IP=%3


:: NOTE: required because when using the script in this context (vagrant, provisioning, batch), the
:: cmd env does not respect the changed PATH var by chocolaty
PATH=%PATH%;C:\ProgramData\chocolatey\bin


choco install -y curl


netsh advfirewall set privateprofile state off
