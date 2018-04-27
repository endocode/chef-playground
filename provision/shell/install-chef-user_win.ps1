$REMOTE_SOURCE_PATH = $args[0].Trim()
$MOUNT_PATH = $args[1].Trim()

# importing configuration variables
. "$REMOTE_SOURCE_PATH\conf.env.ps1"


secedit.exe /configure /db C:\Windows\security\new.sdb /cfg $REMOTE_SOURCE_PATH\secconfig.cfg /areas SECURITYPOLICY

$Username = $PLATFORM_USER_NAME
$Password = $PLATFORM_USER_PW

$group = "Administrators"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never

    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

