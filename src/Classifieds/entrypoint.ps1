(Get-Content -Raw C:\inetpub\wwwroot\Classifieds\web.config) -replace '###ReplaceClassifiedsConnectionString###', $env:ConnectionStringClassifieds | Set-Content -NoNewLine C:\inetpub\wwwroot\Classifieds\web.config
(Get-Content -Raw C:\inetpub\wwwroot\Classifieds\web.config) -replace '###ReplaceTimeTrackerConnectionString###', $env:ConnectionStringTimeTracker | Set-Content -NoNewLine C:\inetpub\wwwroot\Classifieds\web.config
#Remove-Item -Path Env:ConnectionString
C:\ServiceMonitor.exe w3svc