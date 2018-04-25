$MOUNTPATH= $args[0].Trim()
secedit.exe /configure /db C:\Windows\security\new.sdb /cfg $MOUNTPATH\assets\win\secconfig.cfg /areas SECURITYPOLICY
powershell.exe $MOUNTPATH\shell\install-chef-user_win.ps1
