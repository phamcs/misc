# Author: Doan Pham
# Purpose: Setup Profile, OpenSSH and powershell modules
# Initiate profiles
if (!(Test-Path -Path $PROFILE))
{ 
  New-Item -Type File -Path $PROFILE -Force 
}
Get-PSSnapin -Registered | Add-PSSnapin
$softLink = "https://dev.superasian.net/repo"
$msiArray = @(
    'AWSToolkitForVisualStudio2010-2012_tk-1.10.0.7.msi'
    'AWSToolsAndSDKForNet_sdk-3.7.660.0_ps-4.1.428.0_tk-1.14.5.2.msi'
    'OpenSSH-Win64-v9.8.3.0.msi'
)
$modArray = @(
    'PowerShellGet'
    'PolicyFileEditor'
    'Powershell-yaml'
    'PSReadline'
    'AWS.Tools.Common'
    'AWSPowershell.NetCore'
)
# Setup PSGallery and install AWS common modules
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
foreach ($mod in $modArray)
{
  Install-Module -Name $mod -AllowClobber -Force
}
# Install Common Tools SDK & Chocolatey
foreach ($msi in $msiArray) {
  msiexec /i $softLink/$msi /qr /norestart
}
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
# Tweak Policies
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell' -Name ExecutionPolicy -Value Unrestricted
Get-ExecutionPolicy -List | Format-Table -hideTableHeader
gpupdate /force
# Setup SSH & enable Admin
Get-WindowsCapability -Name OpenSSH.Server* -Online | Add-WindowsCapability -Online
Set-Service -Name sshd -StartupType Automatic -Status Running
net user administrator /active:yes
Write-Host "####################################"
Write-Host "## Remember to set Admin Password ##"
Write-Host "####################################"
# Opens port 22 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for OpenSSH Server [TCP 22]'
    Direction   = 'Inbound'
    DisplayName = 'OpenSSH Server (TCP)'
    LocalPort   = 22
    Profile     = 'Any'
    Protocol    = 'TCP'
}
# Setup default shell to powershell.exe
$shellParams = @{
    Path         = 'HKLM:\SOFTWARE\OpenSSH'
    Name         = 'DefaultShell'
    Value        = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    PropertyType = 'String'
    Force        = $true
}
New-ItemProperty @shellParams

# Setup WSL & Reboot
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2; wsl --update;
$reboot = Read-Host "Do you want to reboot the computer? (y/n)"
if ($reboot -eq "y") {
    Restart-Computer -Force
} else {
    Write-Host "Reboot cancelled."
}
