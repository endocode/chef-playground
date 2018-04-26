$CONF_FILE_PATH = $args[0].Trim()

cmd.exe /c "move /y $CONF_FILE_PATH $CONF_FILE_PATH.tmp"
cmd.exe /c "TYPE $CONF_FILE_PATH.tmp | MORE /P > $CONF_FILE_PATH && DEL $CONF_FILE_PATH.tmp"

(Get-Content $CONF_FILE_PATH) | % {
    if( $_.Length -gt 0 ){
        $str = $_ -replace '"', ''
        return "SET $str"
    } else {
        return $_
    }
} | Set-Content "$CONF_FILE_PATH.bat"

(Get-Content $CONF_FILE_PATH) | % {
    if( $_.Length -gt 0 ){
        $str = $_ -replace '=true', '=$true' -replace '=false', '=$false'
        return "`$$str"
    } else {
        return $_
    }
} | Set-Content "$CONF_FILE_PATH.ps1"
