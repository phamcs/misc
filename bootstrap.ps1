# Author: Doan Pham
# Purpose: Setup Profile, WinRM and necessary software
# Initiate profiles
if (!(Test-Path -Path $PROFILE.AllUsersAllHosts))
{ New-Item -Type File -Path $PROFILE.AllUsersAllHosts -Force }
Get-PSSnapin -Registered | Add-PSSnapin
$softLink = "http://phamcs.duckdns.org/downloads"
$msiArray = "7z1900-x64.msi", "Notepad++7.6.6.msi", "VirtualBox-6.1.14-r140239.msi", "AWSCLIV2.msi", "AWSToolsAndSDKForNet_sdk-3.5.119.0_ps-4.1.9.0_tk-1.14.5.0.msi", "node-v14.16.0-x64.msi", "vagrant_2.2.14_x86_64.msi", "chef-workstation-20.8.125-1-x64.msi"
$polArray = "LocalMachine", "CurrentUser"
# Tweak Policies
$polArray | ForEach-Object (Invoke-Command -ScriptBlock {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force})
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\PowerShell -Name ExecutionPolicy -Value Unrestricted
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
$modArray = "PowerShellGet", "PolicyFileEditor", "powershell-yaml", "AWS.Tools.Common", "AWSPowershell.NetCore"
foreach ($mod in $modArray)
{
  Install-Module -Name $mod -AllowClobber -Force
}
# Install software default
Write-Host "#########################################################"
Write-Host "### BEGIN installing application in PARALLEL mode. ######"
Write-Host "#########################################################"
Write-Host "### >> PAY DETAIL ATTENTION to the ALERTS MESSAGE. << ###"
Write-Host "### >> It's not ERROR. Wait for Windows to FINISH. << ###"
Write-Host "### >> !! OR CLICK RETRY !! DO NOT CLICK CANCEL !! << ###"
Write-Host "#########################################################"
$dirArray = "C:\Python27", "C:\HashiCorp", "C:\opscode"
foreach ($dir in $dirArray)
{
  if (!(Test-Path -Path $dir)) { New-Item -Type Directory -Path $dir -Force }
}
msiexec /i $softLink/python-2.7.18.amd64.msi TARGETDIR=C:\Python27 /qr
foreach ($msi in $msiArray)
{
  msiexec /i $softLink/$msi /qr /norestart
}
$appArray = "Postman-win64-7.36.1-Setup.exe", "VSCodeUserSetup-x64-1.52.1.exe"
foreach ($app in $appArray) {
  Invoke-WebRequest -Uri $softLink/$app -UseBasicParsing -OutFile "C:\Temp\$app"
}
$postArgs = { C:\Temp\Postman-win64-7.36.1-Setup.exe /S /v/qn }
$vscodeArgs = { C:\Temp\VSCodeUserSetup-x64-1.52.1.exe /S /v/qn }
Invoke-Command -ScriptBlock $postArgs
Invoke-Command -ScriptBlock $vscodeArgs
# $appArray | ForEach-Object (Invoke-Command -ScriptBlock { Start-Process /wait "C:\Temp\$app /S /v/qn" })
# Adding new Path to ENV
Set-Item -Path Env:Path -Value ($Env:Path + ";C:\Python27;C:\Python27\Scripts\;C:\HashiCorp\Vagrant\bin;C:\opscode\chef-workstation\bin;C:\opscode\chef-workstation\embedded\bin")
# Setup WSL features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
msiexec /i $sofLink/wsl_update_x64.msi /update /qn /norestart
wsl --set-default-version 2
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile "C:\Temp\Ubuntu.appx" -UseBasicParsing
Add-AppxPackage -Path "C:\Temp\Ubuntu.appx" -ForceApplicationShutdown
# Add 10 min waiting for application installing finish
Start-Sleep -s 600 ;
# Cleanup after install
Get-ChildItem  -Path "C:\Temp\" -Recurse  | Remove-Item -Force -Recurse
Restart-Computer -Force
