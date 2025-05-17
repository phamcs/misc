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
# Enables the WinRM service and sets up the HTTP listener
Enable-PSRemoting -Force

# Opens port 5985,5986 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5985-5986]'
    Direction   = 'Inbound'
    DisplayName = 'Windows Remote Management (HTTP/HTTPS-In)'
    LocalPort   = 5985-5986
    Profile     = 'Any'
    Protocol    = 'TCP'
}
New-NetFirewallRule @firewallParams

# Allows local user accounts to be used with WinRM
# This can be ignored if using domain accounts
$tokenFilterParams = @{
    Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Name         = 'LocalAccountTokenFilterPolicy'
    Value        = 1
    PropertyType = 'DWORD'
    Force        = $true
}
New-ItemProperty @tokenFilterParams
# Create self signed certificate
$certParams = @{
    CertStoreLocation = 'Cert:\LocalMachine\My'
    DnsName           = $env:COMPUTERNAME
    NotAfter          = (Get-Date).AddYears(1)
    Provider          = 'Microsoft Software Key Storage Provider'
    Subject           = "CN=$env:COMPUTERNAME"
}
$cert = New-SelfSignedCertificate @certParams

# Create HTTPS listener
$httpsParams = @{
    ResourceURI = 'winrm/config/listener'
    SelectorSet = @{
        Transport = "HTTPS"
        Address   = "*"
    }
    ValueSet = @{
        CertificateThumbprint = $cert.Thumbprint
        Enabled               = $true
    }
}
New-WSManInstance @httpsParams

# Setup SSH
Get-WindowsCapability -Name OpenSSH.Server* -Online |
    Add-WindowsCapability -Online
Set-Service -Name sshd -StartupType Automatic -Status Running

$firewallParams = @{
    Name        = 'sshd-Server-In-TCP'
    DisplayName = 'Inbound rule for OpenSSH Server (sshd) on TCP port 22'
    Action      = 'Allow'
    Direction   = 'Inbound'
    Enabled     = 'True'  # This is not a boolean but an enum
    Profile     = 'Any'
    Protocol    = 'TCP'
    LocalPort   = 22
}
New-NetFirewallRule @firewallParams

# Setup default shell
# Set default to powershell.exe
$shellParams = @{
    Path         = 'HKLM:\SOFTWARE\OpenSSH'
    Name         = 'DefaultShell'
    Value        = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    PropertyType = 'String'
    Force        = $true
}
New-ItemProperty @shellParams

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
