& $PSScriptRoot\Copy-Framework.ps1

$env:COMPLUS_InstallRoot = Resolve-Path "$PSScriptRoot\..\framework"
try {
    & $PSScriptRoot\..\net-apps\net-cli\bin\debug\net-cli.exe
}
finally {
    $env:COMPLUS_InstallRoot = $Null
}
