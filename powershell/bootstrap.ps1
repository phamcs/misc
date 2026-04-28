# Author: Doan Pham
# Purpose: Setup Profile, OpenSSH and powershell modules
# Initiate profiles
if (!(Test-Path -Path $PROFILE))
{
  New-Item -Type File -Path $PROFILE -Force
}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Get-PSSnapin -Registered | Add-PSSnapin
$softLink = "https://www.superasian.net/repo"
$msiPackages = @(
    '7z2301-x64.msi'
    'AWSCLIV2.msi'
    'npp.8.9.4.Installer.x64.msi'
    'OpenSSH-Win64-v10.0.0.0.msi'
)
$basicmodules = @(
    'PowerShellGet'
    'PolicyFileEditor'
    'Powershell-yaml'
    'PSReadline'
)
$awsmodules = @(
    'AWS.Tools.AutoScaling'
    'AWS.Tools.CloudFormation'
    'AWS.Tools.CloudWatchLogs'
    'AWS.Tools.Common'
    'AWS.Tools.EC2'
    'AWS.Tools.Elasticsearch'
    'AWS.Tools.IdentityManagement'
    'AWS.Tools.Lambda'
    'AWS.Tools.RDS'
    'AWS.Tools.Route53'
    'AWS.Tools.S3'
    'AWS.Tools.SecretsManager'
    'AWS.Tools.SecurityToken'
    'AWSLambdaPSCore'
    'AWSPowershell.NetCore'
)
# Install Common Tools
foreach ($msi in $msiPackages) {
  Invoke-WebRequest -Uri $softLink/$msi -OutFile "C:\TEMP\$msi"
  msiexec /i "C:\TEMP\$msi" /passive
}
# Setup PSGallery as trusted repo
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
foreach ($mod in $basicmodules)
{
  Install-Module -Name $mod -AllowClobber -Force
}
# Install AWS Modules
foreach ($mod in $awsmodules)
{
  Install-Module -Name $mod -AllowClobber -Force
}
# Install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
# Tweak Policies
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell' -Name ExecutionPolicy -Value Unrestricted
Get-ExecutionPolicy -List | Format-Table -hideTableHeader
gpupdate /force
# Set Local Admin Account to Active
net user administrator /active:yes
Write-Host "####################################"
Write-Host "## Remember to set Admin Password ##"
Write-Host "####################################"
# Opens port 22 for all profiles
$FirewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for OpenSSH Server [TCP 22]'
    Direction   = 'Inbound'
    DisplayName = 'OpenSSH Server (TCP)'
    LocalPort   = 22
    Profile     = 'Any'
    Protocol    = 'TCP'
}
if (-not (Get-NetFirewallRule -DisplayName 'OpenSSH Server (TCP)' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule @FirewallParams
}
# Setup default shell to powershell.exe
$OpenSSHParams = @{
    Path         = "HKLM:\SOFTWARE\OpenSSH"
    Name         = "DefaultShell"
    Value        = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    PropertyType = "String"
    Force        = $true
}
New-ItemProperty @OpenSSHParams

# Setup WSL & Reboot
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2; wsl --update;
Restart-Computer -Force

