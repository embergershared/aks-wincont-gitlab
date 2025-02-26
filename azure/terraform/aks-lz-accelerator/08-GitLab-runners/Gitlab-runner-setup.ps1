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

$core_packages = @(
  # "adobereader",
  # "firefox",
  # "brave",
  "notepadplusplus",
  # "zoomit",
  "git",
  "gh",
  "azure-cli",
  "vscode",
  # "visualstudio2022enterprise",
  "sysinternals",
  "microsoftazurestorageexplorer",
  "terraform",
  "python3",
  "kubectx",
  "kubens",
  "kubernetes-cli",
  "azure-kubelogin",
  "kubernetes-helm",
  # "openlens",
  "azure-powershell",
  "powershell-core",
  # "vnc-viewer",
  # "dropbox",
  "winscp",
  # "vlc",
  "7zip",
  # "paint.net",
  # "syncbackfree",
  "nvidia-display-driver",
  "nerd-fonts-cascadiacode",
  "nerd-fonts-jetbrainsmono",
  "nerd-fonts-firamono",
  "nerd-fonts-firacode",
  "cascadiamono",
  "cascadiacode",
  "ubuntu.font",
  # "oh-my-posh",
  "jq",
  "openssl",
  "bind-toolsonly", # installs dig
  "telnet"
)

$kubernetes_packages = @(
  "azure-cli",
  "kubectx",
  # "kubens",
  "kubernetes-cli",
  "azure-kubelogin",
  "kubernetes-helm"
  # "openlens"
)

$secondary_packages = @(
  "wireshark",
  "postman",
  "docker-desktop",
  "azure-functions-core-tools --params='/x64:true'",
  "azure-data-studio",
  # "tunein-radio",
  # "spotify",
  # "rdm",
  # "openvpn",
  # "itunes",
  # "whatsapp", #whatsapp --version 2.2306.9
  # "zoom",
  # "icloud",
  # "logi-tune",
  # "resharper",
  "dotnet",
  "dotnet-8.0-runtime"
)
$install_packages = @(
  "wireshark",
  "postman",
  "adobereader",
  "firefox",
  "notepadplusplus",
  "zoomit",
  "git",
  "gh",
  "azure-cli",
  "vscode",
  "visualstudio2022enterprise",
  "sysinternals",
  "microsoftazurestorageexplorer",
  "jdk8",
  "docker-desktop",
  "azure-functions-core-tools --params='/x64:true'",
  "terraform",
  "python3",
  "azure-data-studio",
  "kubectx",
  "kubens",
  "kubernetes-cli",
  "azure-kubelogin",
  "kubernetes-helm",
  "krew",
  "flux",
  "argocd-cli",
  "openlens",
  "visioviewer",
  "azure-powershell",
  "powershell-core",
  "vnc-viewer",
  "dropbox",
  "sonos-s1-controller",
  "winscp",
  "filezilla",
  "telegram",
  "vlc",
  "7zip",
  "paint.net",
  "tunein-radio",
  "spotify",
  "rdm",
  "openvpn",
  "github-desktop",
  "itunes",
  "syncbackfree",
  "skype",
  "whatsapp", #whatsapp --version 2.2306.9
  "zoom",
  "freshbing",
  "icloud",
  "logi-tune",
  "nvidia-display-driver",
  "resharper",
  "dotnet",
  "dotnet-8.0-runtime",
  "nerd-fonts-cascadiacode",
  "nerd-fonts-jetbrainsmono",
  "nerd-fonts-firamono",
  "nerd-fonts-firacode",
  "cascadiamono",
  "cascadiacode",
  "ubuntu.font",
  "oh-my-posh",
  "jq",
  "openssl",
  "bind-toolsonly",
  "telnet",
  "nodejs" # 'nodejs-lts --version="20.18.0"'
)

Install-ChocoPackage -Packages $core_packages
Install-ChocoPackage -Packages $secondary_packages