(Get-Content -Raw C:\inetpub\wwwroot\TimeTracker\web.config) -replace '###ReplaceTimeTrackerConnectionString###', $env:ConnectionStringTimeTracker | Set-Content -NoNewLine C:\inetpub\wwwroot\TimeTracker\web.config
#Remove-Item -Path Env:ConnectionString
C:\ServiceMonitor.exe w3svc