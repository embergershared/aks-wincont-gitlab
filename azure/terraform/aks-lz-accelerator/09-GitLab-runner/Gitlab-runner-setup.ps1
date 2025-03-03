param(
  [Parameter(Mandatory = $true)][string] $GitLabRunnerToken,
  [Parameter(Mandatory = $true)][string] $StAcctName,
  [Parameter(Mandatory = $true)][string] $StShareName,
  [Parameter(Mandatory = $true)][string] $StAcctAccessKey
)

$filePath = "C:\GitLab-Runner-setup_log.txt"
New-Item -Path $filePath -ItemType File -Force
Add-Content -Path $filePath -Value "$(Get-Date): GitLab Runner setup started"
Add-Content -Path $filePath -Value "$(Get-Date): Parameters received: GitLabRunnerToken=$GitLabRunnerToken, StAcctName=$StAcctName, StShareName=$StShareName, StAcctAccessKey=$StAcctAccessKey"

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
  # "argocd-cli",
  # "azure-data-studio",
  # "bind-toolsonly",
  # "cascadiacode",
  # "cascadiamono",
  # "docker-desktop",
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
  # "nodejs", # 'nodejs-lts --version="20.18.0"'
  # "winscp",
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
Add-Content -Path $filePath -Value "$(Get-Date): GitLab Runner installed"

# Add additional entries to the PATH
[Environment]::SetEnvironmentVariable("Path", "$($env:path);C:\Program Files\Git\bin;C:\Program Files\Microsoft VS Code\bin;C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin;C:\Program Files\PowerShell\7;C:\Program Files\SqlCmd", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
Add-Content -Path $filePath -Value "$(Get-Date): Added paths to the PATH environment variable"

# # Mount the Azure File Share as Z drive on the GitLab runner VM
# $connectTestResult = Test-NetConnection -ComputerName "$StAcctName.file.core.windows.net" -Port 445
# if ($connectTestResult.TcpTestSucceeded) {
#   # Save the password so the drive will persist on reboot
#   cmd.exe /C "cmdkey /add:`"$StAcctName.file.core.windows.net`" /user:`"localhost\$StAcctName`" /pass:`"$StAcctAccessKey`""
#   # Mount the drive
#   New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$StAcctName.file.core.windows.net\$StShareName" -Persist
#   Get-ChildItem Z:\ | Out-File -FilePath $filePath
#   Add-Content -Path $filePath -Value "$(Get-Date): Mounted Azure File Share as Z drive"
# }
# else {
#   Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
#   Add-Content -Path $filePath -Value "$(Get-Date): Unable to reach the Azure storage account via port 445"
# }

# TODO: add code to retrieve BACPAC files from Azure Blob with managed identity + Private endpoint

# Restart the machine
Add-Content -Path $filePath -Value "$(Get-Date): Launching Server restart"
Restart-Computer -Force