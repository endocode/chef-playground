$confFilePath = $args[0].Trim()

cmd.exe /c "move /y $confFilePath $confFilePath.tmp"
cmd.exe /c "TYPE $confFilePath.tmp | MORE /P > $confFilePath && DEL $confFilePath.tmp"

(Get-Content $confFilePath) | % {
    if( $_.Length -gt 0 ){
        $str = $_ -replace '"', ''
        return "SET $str"
    } else {
        return $_
    }
} | Set-Content "$confFilePath.bat"

(Get-Content $confFilePath) | % {
    if( $_.Length -gt 0 ){
        $str = $_ -replace '=true', '=$true' -replace '=false', '=$false'
        return "`$$str"
    } else {
        return $_
    }
} | Set-Content "$confFilePath.ps1"

