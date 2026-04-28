# Author: Doan Pham
# Purpose: Remove AWS Powershell Modules
# Initiate profiles
if (!(Test-Path -Path $PROFILE))
{
  New-Item -Type File -Path $PROFILE -Force
}
# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
PSScriptAnalyzer(PSAvoidUsingCmdletAliases) ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade -y chocolatey
$awsmodules = @(
  'AWS.Tools.AutoScaling'
  'AWS.Tools.CloudFormation'
  'AWS.Tools.CloudWatchLogs'
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
)

foreach ($mod in $awsmodules) {
  Uninstall-Module -ModuleInfo $mod -Force
 }