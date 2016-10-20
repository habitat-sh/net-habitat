$installedFramework = "$env:windir\Microsoft.NET\Framework\v4.0.30319"
$isolatedFramework = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "$PSScriptRoot\..\Framework"
)

if(Test-Path "$isolatedFramework\v4.0.30319") {
    Write-Host "Isolated Framework already in place..."
    return
}

Write-Host "Copying $installedFramework to $isolatedFramework..."
if(!(Test-Path $isolatedFramework)) { mkdir $isolatedFramework | Out-Null }

Copy-Item $installedFramework $isolatedFramework -Recurse

# Yeah I copy and pasted...don't judge!
$installedFramework = "$env:windir\Microsoft.NET\Framework64\v4.0.30319"
$isolatedFramework = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "$PSScriptRoot\..\Framework64"
)

if(Test-Path "$isolatedFramework\v4.0.30319") {
    Write-Host "Isolated Framework64 already in place..."
    return
}

Write-Host "Copying $installedFramework to $isolatedFramework..."
if(!(Test-Path $isolatedFramework)) { mkdir $isolatedFramework | Out-Null }

Copy-Item $installedFramework $isolatedFramework -Recurse
