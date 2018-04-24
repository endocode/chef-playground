@echo off


:: NOTE: required because when using the script in this context (vagrant, provisioning, batch), the
:: cmd env does not respect the changed PATH var by chocolaty
PATH=%PATH%;C:\ProgramData\chocolatey\bin


choco install -y curl
