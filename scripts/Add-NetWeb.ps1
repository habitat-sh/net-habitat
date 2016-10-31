$appName = "net-web2"
$port = 8080

mkdir '$PSScriptRoot\..\framework64\v4.0.30319\Temporary ASP.NET Files'

if(!(Test-Path "IIS:\AppPools\$appName\")) {
    New-WebAppPool -Name $appName
    Set-ItemProperty IIS:\AppPools\$appName -name processModel -value @{setProfileEnvironment="true"}
}

if(!(Test-Path "IIS:\Sites\$appName\")) {
    New-Website -Name $appName -Port $port -PhysicalPath (Resolve-Path "$PSScriptRoot\..\net-apps\net-web\") -ApplicationPool $appName
}

# need to start web app for virtual app pool identity to be created
Invoke-WebRequest "http://localhost:$port"

# You need sysinternals tool PsGetsid
$sid=(PsGetsid.exe $appName)[1]

if(!(Test-Path HKU:\)){
    New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
}
if(!(Get-ItemProperty -Path HKU:\$sid\Environment -Name COMPLUS_InstallRoot -ErrorAction SilentlyContinue)){
    New-ItemProperty -Path HKU:\$sid\Environment -Name COMPLUS_InstallRoot -Value (Resolve-Path "$PSScriptRoot\..\framework64")
}
if(!(Get-ItemProperty -Path HKU:\$sid\Environment -Name COMPLUS_version -ErrorAction SilentlyContinue)){
    New-ItemProperty -Path HKU:\$sid\Environment -Name COMPLUS_version -Value "v4.0.30319"
}
if(!(Get-ItemProperty -Path HKU:\$sid\Environment -Name DEVPATH -ErrorAction SilentlyContinue)){
    New-ItemProperty -Path HKU:\$sid\Environment -Name DEVPATH -Value (Resolve-Path "$PSScriptRoot\..\net-apps\net-web\assemblies")
}

Copy-Item "$PSScriptRoot\..\net-apps\net-web\assemblies\w3wp.exe.config" "$env:windir\system32\inetsrv"
iisreset
