cd /d %~dp0
PsExec64.exe -accepteula -d -i -u "NT AUTHORITY\LocalService" "%~dp0test.bat"
