# Author: Doan Pham
# Purpose: Install Apps
# Initiate profiles
if (!(Test-Path -Path $PROFILE))
{ 
  New-Item -Type File -Path $PROFILE -Force 
}
$appArray = @(
    '7zip'
    'awscli'
    'dotnet-9.0-runtime'
    'dotnet-9.0-sdk'
    'git'
    'golang'
    'netfx-4.8.1'
    'nodejs-lts'
    'notepadplusplus'
    'python3'
    'ruby'
    'vscode'
)
# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
PSScriptAnalyzer(PSAvoidUsingCmdletAliases) ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
foreach ($app in $appArray) {
  choco install -y $app --force
}
# Reboot your computer to apply changes
Restart-Computer -Force
