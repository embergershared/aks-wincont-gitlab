# 1. Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# 2. Chocolatey functions
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
  "notepadplusplus"
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
  # "vscode",
  # "winscp"
)

Install-ChocoPackage -Packages $gl_runner_packages
