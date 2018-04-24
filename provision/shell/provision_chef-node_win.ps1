secedit.exe /configure /db C:\Windows\security\new.sdb /cfg $args[0]\assets\win\secconfig.cfg /areas SECURITYPOLICY
powershell.exe $args[0]\shell\install-chef-user_win.ps1