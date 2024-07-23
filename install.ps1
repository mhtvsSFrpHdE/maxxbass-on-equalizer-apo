$localServiceProfile = "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming"
$wavesAudioPath = "Waves Audio\Preferences"
$wavesConfigFileName = "V9PluginFolder_ScanView.txt"
$askOpenPluginPath = "C:\Program Files (x86)\Waves\Plug-Ins V9"

$wavesAudioPath = Join-Path $localServiceProfile $wavesAudioPath
$wavesConfigFileName = Join-Path $wavesAudioPath $wavesConfigFileName

# Test local service profile
if ( (Test-Path $localServiceProfile) -eq $false) {
    Write-Host "Didn't find local service path on your system"
    Write-Host $localServiceProfile
    exit
}

# Ask Plug-Ins V9 install folder
. ".\Read-FolderBrowserDialog.ps1"
$getResult = Read-FolderBrowserDialog "Choose your Plug-Ins V9 folder" $askOpenPluginPath
if ($getResult.success -eq $true) {
    $askOpenPluginPath = $getResult.result
}
else{
    exit
}

if ( (Test-Path $wavesAudioPath) -eq $false) {
    New-Item -ItemType Directory $wavesAudioPath
}

"folders:`n  - $($askOpenPluginPath)" | Out-File "$($wavesConfigFileName)" -Encoding utf8 -NoNewline

Get-Process -Name audiodg | Stop-Process -Force
