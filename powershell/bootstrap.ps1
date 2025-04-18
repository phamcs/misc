# Author: Doan Pham
# Purpose: Setup Profile, WinRM and necessary software
# Initiate profiles
if (!(Test-Path -Path $PROFILE))
{ 
  New-Item -Type File -Path $PROFILE -Force 
}
Get-PSSnapin -Registered | Add-PSSnapin
$softLink = "https://dev.superasian.net/repo"
$dirArray = @(
    'C:\HashiCorp'
    'C:\opscode'
)
$msiArray = @(
    'AWSToolkitForVisualStudio2010-2012_tk-1.10.0.7.msi'
    'AWSToolsAndSDKForNet_sdk-3.7.660.0_ps-4.1.428.0_tk-1.14.5.2.msi'
)
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
# Tweak Policies
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
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
# Install software
foreach ($dir in $dirArray)
{
  if (!(Test-Path -Path $dir)) { New-Item -Type Directory -Path $dir -Force }
}
foreach ($msi in $msiArray) {
  msiexec /i $softLink/$msi /qr /norestart
}
# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
foreach ($app in $appArray) {
  choco install -y $app --force
} 
# Adding new Path to ENV
Set-Item -Path Env:Path -Value ($Env:Path + "C:\HashiCorp\Vagrant\bin;C:\opscode\chef-workstation\bin;C:\opscode\chef-workstation\embedded\bin")
# Setup WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2; wsl --update;
wsl --install -d Ubuntu-22.04 -n; wsl -s Ubuntu-22.04
# Reboot your computer to apply changes
$reboot = Read-Host "Do you want to reboot the computer? (y/n)"
if ($reboot -eq "y") {
    Restart-Computer -Force
} else {
    Write-Host "Reboot cancelled."
}
