param(
  [Parameter(Mandatory = $true)][string] $GitLabRunnerToken
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
  "sqlcmd"
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

# Restart the machine
Restart-Computer -Force