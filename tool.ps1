@echo off
set outfile=%TEMP%\purple_scan_%COMPUTERNAME%.txt
echo Purple Team - Local Inventory > "%outfile%"
echo Generated: %DATE% %TIME% >> "%outfile%"
echo ---------------------------- >> "%outfile%"

echo [System Info] >> "%outfile%"
systeminfo >> "%outfile%"
echo. >> "%outfile%"

echo [Current User] >> "%outfile%"
whoami /all >> "%outfile%"
echo. >> "%outfile%"

echo [Network Interfaces] >> "%outfile%"
ipconfig /all >> "%outfile%"
echo. >> "%outfile%"

echo [Installed HotFixes (WMIC)] >> "%outfile%"
wmic qfe get HotFixID,Description,InstalledOn /format:table >> "%outfile%"
echo. >> "%outfile%"

echo [Installed HotFixes (PowerShell)] >> "%outfile%"
powershell -Command "Get-HotFix | Select-Object HotFixID, InstalledOn | Format-Table -AutoSize" >> "%outfile%"
echo. >> "%outfile%"

echo [Running Processes] >> "%outfile%"
tasklist /V >> "%outfile%"
echo. >> "%outfile%"

echo [Open Network Connections] >> "%outfile%"
netstat -ano >> "%outfile%"
echo. >> "%outfile%"

echo Done. Results saved to: %outfile%
pause