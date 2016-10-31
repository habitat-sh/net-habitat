& $PSScriptRoot\Copy-Framework.ps1

$env:COMPLUS_InstallRoot = Resolve-Path "$PSScriptRoot\..\framework"
$env:COMPLUS_version = "v4.0.30319"
$env:DEVPATH = Resolve-Path "$PSScriptRoot\..\net-apps\net-cli\gac_assemblies"
try {
    & $PSScriptRoot\..\net-apps\net-cli\bin\debug\net-cli.exe
}
finally {
    $env:COMPLUS_InstallRoot = $Null
    $env:COMPLUS_version = $Null
    $env:DEVPATH = $Null
}
