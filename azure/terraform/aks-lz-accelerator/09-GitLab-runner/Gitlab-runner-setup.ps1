param(
  [Parameter(Mandatory = $true)][string] $GitLabRunnerToken,
  [Parameter(Mandatory = $true)][string] $StorageAccountName,
  [Parameter(Mandatory = $true)][string] $StorageAccountFileShareName,
  [Parameter(Mandatory = $true)][string] $StorageAccountFileShareAccessKey
)

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Chocolatey functions
Function Install-ChocoPackage {
  param (
    [Parameter(Mandatory = $true)]
    [Object]$Packages
  )

  foreach ($package in $Packages) {
    $command = "choco install $package -y"
    Write-Host
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
  "vscode".
  "sqlpackage",
  # "argocd-cli",
  # "azure-data-studio",
  # "bind-toolsonly",
  # "cascadiacode",
  # "cascadiamono",
  # "docker-desktop",
  # "dotnet",
  # "dotnet-8.0-runtime",
  # "firefox",
  # "flux",
  # "gh",
  # "jdk8",
  # "krew",
  # "kubectx",
  # "kubens",
  # "microsoftazurestorageexplorer",
  # "nerd-fonts-cascadiacode",
  # "nerd-fonts-firacode",
  # "nerd-fonts-firamono",
  # "nerd-fonts-jetbrainsmono",
  # "nodejs" # 'nodejs-lts --version="20.18.0"'
  # "winscp"
  "sqlcmd"
)
Install-ChocoPackage -Packages $gl_runner_packages

# Set VM time zone
Set-TimeZone -Name "Eastern Standard Time"

# Install Docker for Windows containers
Enable-WindowsOptionalFeature -Online -FeatureName containers -All -NoRestart
## Require Restart

curl.exe -o docker.zip -LO https://download.docker.com/win/static/stable/x86_64/docker-20.10.13.zip
Expand-Archive docker.zip -DestinationPath C:\
[Environment]::SetEnvironmentVariable("Path", "$($env:path);C:\docker", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
dockerd --register-service
Start-Service docker
#docker run hello-world
# Pull build images
docker pull mcr.microsoft.com/dotnet/framework/aspnet:3.5-windowsservercore-ltsc2022

# Note:
# - should solve the need for: `Docker Desktop` / Right-click / `switch to windows containers`
# - May also save the use of this: `& 'C:\Program Files\Docker\Docker\DockerCli.exe' -SwitchDaemon -SwitchWindowsEngine`

# Install GitLab Runner
New-Item -Path 'C:\GitLab-Runner' -ItemType Directory
cd 'C:\GitLab-Runner'

## Download binary
Invoke-WebRequest -Uri "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-windows-amd64.exe" -OutFile "gitlab-runner.exe"

## Register the runner (steps below), then run
.\gitlab-runner.exe install
.\gitlab-runner.exe start

# Register GitLab Runner
$TOKEN = $GitLabRunnerToken
.\gitlab-runner.exe register --url https://gitlab.com --token $TOKEN --executor "shell" --non-interactive --description "hww poc windows runner"

# Add additional entries to the PATH
[Environment]::SetEnvironmentVariable("Path", "$($env:path);C:\Program Files\Git\bin;C:\Program Files\Microsoft VS Code\bin;C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin;C:\Program Files\PowerShell\7;C:\Program Files\SqlCmd", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")

# Mount the Azure File Share
$connectTestResult = Test-NetConnection -ComputerName $StorageAccountName.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
  # Save the password so the drive will persist on reboot
  cmd.exe /C "cmdkey /add:`"$StorageAccountName.file.core.windows.net`" /user:`"localhost\$StorageAccountName`" /pass:`"$StorageAccountFileShareAccessKey`""
  # Mount the drive
  New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$StorageAccountName.file.core.windows.net\$StorageAccountFileShareName" -Persist
}
else {
  Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}


# Restart the machine
Restart-Computer -Force