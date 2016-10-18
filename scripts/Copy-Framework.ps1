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
