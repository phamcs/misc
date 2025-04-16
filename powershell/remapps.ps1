# Author: Doan Pham
# Purpose: Remove all Apps
# Initiate profiles
if (!(Test-Path -Path $PROFILE))
{ 
  New-Item -Type File -Path $PROFILE -Force 
}
$appArray = @(
    '7zip'
    'awscli'
    'chef-workstation'
    'golang'
    'nodejs-lts'
    'notepadplusplus'
    'python3'
    'ruby'
    'vagrant'
    'virtualbox'
    'VisualStudioCode'
)
# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
foreach ($app in $appArray) {
  choco uninstall -y $app
}
# Reboot your computer to apply changes
Restart-Computer -Force

