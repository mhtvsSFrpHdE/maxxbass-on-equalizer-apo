$localServiceProfile = "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming"
$wavesAudioRootPath = "Waves Audio"

$wavesAudioRootPath = Join-Path $localServiceProfile $wavesAudioRootPath

Remove-Item -Recurse -Force $wavesAudioRootPath
