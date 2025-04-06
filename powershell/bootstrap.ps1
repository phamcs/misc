# Author: Doan Pham
# Purpose: Setup Profile, WinRM and necessary software
# Initiate profiles
if (!(Test-Path -Path $PROFILE.AllUsersAllHosts))
{ New-Item -Type File -Path $PROFILE.AllUsersAllHosts -Force }
Get-PSSnapin -Registered | Add-PSSnapin
$softLink = "https://dev.superasian.net/repo"
$dirArray = @(
    'C:\HashiCorp'
    'C:\opscode'
)
$msiArray = @(
    'AWSToolkitForVisualStudio2010-2012_tk-1.10.0.7.msi'
    'AWSCLIV2.msi'
    'AWSToolsAndSDKForNet_sdk-3.5.119.0_ps-4.1.9.0_tk-1.14.5.0.msi'
)
$appArray = @(
    '7zip'
    'chef-workstation'
    'nodejs-lts'
    'notepadplusplus'
    'postman'
    'python3'
    'vagrant'
    'vim-x64'
    'virtualbox'
    'VisualStudioCode'
)
$polArray = @(
    'LocalMachine'
    'MachinePolicy'
)
$modArray = @(
    'PowerShellGet'
    'PolicyFileEditor'
    'Powershell-yaml'
    'AWS.Tools.Common'
    'AWSPowershell.NetCore'
)
# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
# Tweak Policies
$polArray | ForEach-Object (Invoke-Command -ScriptBlock {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force})
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell' -Name ExecutionPolicy -Value Unrestricted
Get-ExecutionPolicy -List | Format-Table -hideTableHeader
gpupdate /force
# Setup WinRM
winrm quickconfig -q
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/client '@{AllowUnencrypted="True"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
Set-Service -Name WinRM -Status Running -PassThru
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
# Setup PSGallery and install AWS common modules
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
foreach ($mod in $modArray)
{
  Install-Module -Name $mod -AllowClobber -Force
}
# Install software
foreach ($dir in $dirArray)
{
  if (!(Test-Path -Path $dir)) { New-Item -Type Directory -Path $dir -Force }
}
foreach ($msi in $msiArray) {
  msiexec /i $softLink/$msi /qr /norestart
}
foreach ($app in $appArray) {
  # Install with chocolatey
  choco install -y $app
} 

# $appArray | ForEach-Object (Invoke-Command -ScriptBlock { Start-Process /wait "C:\Temp\$app /S /v/qn" })
# Adding new Path to ENV
Set-Item -Path Env:Path -Value ($Env:Path + "C:\HashiCorp\Vagrant\bin;C:\opscode\chef-workstation\bin;C:\opscode\chef-workstation\embedded\bin")
# Setup WSL features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
wsl --update -y
wsl --install -d Ubuntu -y
wsl --set-default Ubuntu --set-version Ubuntu 22.04
#Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-2204 -OutFile "C:\Temp\Ubuntu.appx" -UseBasicParsing
#Add-AppxPackage -Path "C:\Temp\Ubuntu.appx" -ForceApplicationShutdown
# Add 10 min waiting for application installing finish
Start-Sleep -s 600 ;
# Cleanup after install
Get-ChildItem  -Path "C:\Temp\" -Recurse  | Remove-Item -Force -Recurse
Restart-Computer -Force
