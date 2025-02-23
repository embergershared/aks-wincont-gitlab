# escape=`
#FROM microsoft/aspnet:3.5-windowsservercore-10.0.14393.1715
FROM mcr.microsoft.com/dotnet/framework/aspnet:3.5-windowsservercore-ltsc2022
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Remove-Website 'Default Web Site';

# Set up website: Classifieds
RUN New-Item -Path 'C:\inetpub\wwwroot\Classifieds' -Type Directory -Force;

RUN New-Website -Name 'ClassifiedsWebSite' -PhysicalPath 'C:\inetpub\wwwroot\Classifieds' -Port 80 -ApplicationPool 'Classic .NET AppPool' -Force;

EXPOSE 8080

COPY ["./entrypoint.ps1", "/"]
COPY [".", "/inetpub/wwwroot/Classifieds"]

RUN $path='C:\inetpub\wwwroot\Classifieds'; `
    $acl = Get-Acl $path; `
    $newOwner = [System.Security.Principal.NTAccount]('BUILTIN\IIS_IUSRS'); `
    $acl.SetOwner($newOwner); `
    dir -r $path | Set-Acl -aclobject  $acl

ENTRYPOINT [ "powershell", "C:/entrypoint.ps1" ]