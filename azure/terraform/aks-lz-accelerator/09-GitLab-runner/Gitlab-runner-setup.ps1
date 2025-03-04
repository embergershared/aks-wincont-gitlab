[CmdletBinding()]

param
( 
  [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$Param1,
  [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$Param2,
  [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$Param3,
  [Parameter(ValuefromPipeline = $true, Mandatory = $true)] [string]$Param4
)

$filePath = "C:\GitLab-Runner-setup_log.txt"
New-Item -Path $filePath -ItemType File -Force
Add-Content -Path $filePath -Value "$(Get-Date): GitLab Runner setup started"
Add-Content -Path $filePath -Value "$(Get-Date): Parameters received: Param1 = ""$($Param1)"", Param2 = ""$($Param2)"", Param3 = ""$($Param3)"", Param4 = ""$($Param4)"""

Add-Content -Path $filePath -Value "$(Get-Date): Setting values from parameters"
$TOKEN = $Param1
$StAcctName = $Param2
$StContainerName = $Param3
$MsiClientId = $Param4
Add-Content -Path $filePath -Value "$(Get-Date): Variables values: TOKEN = ""$($TOKEN)"", StAcctName = ""$($StAcctName)"", StContainerName = ""$($StContainerName)"", MsiClientId = ""$($MsiClientId)"""

# Set VM time zone
Set-TimeZone -Name "Eastern Standard Time"
Add-Content -Path $filePath -Value "$(Get-Date): Time zone set to EST"

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Add-Content -Path $filePath -Value "$(Get-Date): Chocolatey installed"

# Chocolatey functions
Function Install-ChocoPackage {
  param (
    [Parameter(Mandatory = $true)]
    [Object]$Packages
  )

  foreach ($package in $Packages) {
    $command = "choco install $package -y"
    Write-Host
    Add-Content -Path $filePath -Value "$(Get-Date): Chocolatey installing package: $package"
    Write-Host "Install-ChocoPackage => Executing: $command"
    Invoke-Expression $command
  }
}

# Install core packages
$gl_runner_packages = @(
  "git",
  "powershell-core",
  "azure-cli",
  "kubernetes-cli",
  "kubernetes-helm"
  "azure-kubelogin",
  "azure-powershell",
  "terraform",
  "jq",
  "openssl",
  "python3",
  "sysinternals",
  "telnet",
  "7zip",
  "notepadplusplus",
  "sqlpackage",
  "sqlcmd",
  "dotnet",
  "vscode"
)
Install-ChocoPackage -Packages $gl_runner_packages
Add-Content -Path $filePath -Value "$(Get-Date): Chocolatey Packages installed"

# Install Docker for Windows containers
Enable-WindowsOptionalFeature -Online -FeatureName containers -All -NoRestart
Add-Content -Path $filePath -Value "$(Get-Date): Added Windows feature containers"
## Require Restart

curl.exe -o docker.zip -LO https://download.docker.com/win/static/stable/x86_64/docker-20.10.13.zip
Expand-Archive docker.zip -DestinationPath C:\
[Environment]::SetEnvironmentVariable("Path", "$($env:path); C:\docker", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
dockerd --register-service
Start-Service docker
#docker run hello-world
Add-Content -Path $filePath -Value "$(Get-Date): Docker installed"

# Install GitLab Runner
New-Item -Path 'C:\GitLab-Runner' -ItemType Directory
Set-Location 'C:\GitLab-Runner'

## Download binary
Invoke-WebRequest -Uri "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-windows-amd64.exe" -OutFile "gitlab-runner.exe"

## Register the runner (steps below), then run
.\gitlab-runner.exe install
.\gitlab-runner.exe start

# Register GitLab Runner
.\gitlab-runner.exe register --url https://gitlab.com --token $TOKEN --executor "shell" --non-interactive --description "hww poc windows runner"
Add-Content -Path $filePath -Value "$(Get-Date): GitLab Runner installed"

# Add additional entries to the PATH
[Environment]::SetEnvironmentVariable("Path", "$($env:path);C:\Program Files\Git\bin;C:\Program Files\Microsoft VS Code\bin;C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin;C:\Program Files\PowerShell\7;C:\Program Files\SqlCmd", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
Add-Content -Path $filePath -Value "$(Get-Date): Added paths to the PATH environment variable"

# Download BACPAC files from Azure Blob
Add-Content -Path $filePath -Value "$(Get-Date): Downloading BACPAC files from Azure Blob"
Add-Content -Path $filePath -Value "$(Get-Date): Creating directory C:\sql-bacpac"
New-Item -Path 'C:\sql-bacpac' -ItemType Directory
Add-Content -Path $filePath -Value "$(Get-Date): Az login with User Assigned Identity"
az login --identity --client-id $MsiClientId
az account show >> $filePath
Add-Content -Path $filePath -Value "$(Get-Date): Loading blob list from Azure Blob Storage Container"
$blobList = az storage blob list --account-name $StAcctName --container-name $StContainerName --auth-mode login | ConvertFrom-Json -Depth 100
foreach ($blob in $blobList) {
  Add-Content -Path $filePath -Value "$(Get-Date): Downloading blob $($blob.name)"
  az storage blob download --account-name $StAcctName --container-name $StContainerName --name $blob.name --file "c:\sql-bacpac\$($blob.name)" --auth-mode login
}
Add-Content -Path $filePath -Value "$(Get-Date): Downloaded BACPAC files from Azure Blob"

# Restart the machine
Add-Content -Path $filePath -Value "$(Get-Date): Launching Server restart"
Restart-Computer -Force