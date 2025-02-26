# Tuning steps

## RDP through Bastion with

```bash
az network bastion rdp --name "snap-hub-sysv" --resource-group "rg-use2-391575-s3-akswincont-avm-hub" --target-resource-id "/subscriptions/4c88693f-5cc9-4f30-9d1e-d58d4221cf25/resourceGroups/rg-use2-391575-s3-akswincont-avm-lz/providers/Microsoft.Compute/virtualMachines/vm-gitlab-nz03" --configure
```

## Gitlab.com project

[hww](https://gitlab.com/southoutsteam/hww)

## Install (Custom script)

- PowerShell 7
- az login
- Download kubectl and kubelogin in a system wide path (aks install-cli equivalent)
- Docker (desktop?)

## Deploy Docker for Windows containers

```bash
# Optionally enable required Windows features if needed
Enable-WindowsOptionalFeature -Online -FeatureName containers –All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All

curl.exe -o docker.zip -LO https://download.docker.com/win/static/stable/x86_64/docker-20.10.13.zip 
Expand-Archive docker.zip -DestinationPath C:\
[Environment]::SetEnvironmentVariable("Path", "$($env:path);C:\docker", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
dockerd --register-service
Start-Service docker
docker run hello-world
```

## Switch docker to Daemon

`& 'C:\Program Files\Docker\Docker\DockerCli.exe' -SwitchDaemon -SwitchWindowsEngine`

## Image build error fix

Docker Desktop > `switch to windows containers`

## Create Role assignments

- GL runner MI:
  - ACrPush on ACR
  - AKS RBAC cluster admin

## Restart gitlab-runner NT service
