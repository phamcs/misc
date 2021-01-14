# Setup O365 login
$runningAzure = Read-Host "Are you connecting to Office 365? (Y/N)"
if($runningAzure -eq "Y"){

$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#Connect-ExchangeOnline -UserPrincipalName <UPN> -ShowProgress $true [-ConnectionUri <URL>] [-AzureADAuthorizationEndPointUri <URL>] [-DelegatedOrganization <String>]
Connect-ExchangeOnline -UserPrincipalName doanph01@noa.nintendo.com -BypassMailboxAnchoring -ConnectionUri https://outlook.office.com/powershell-liveid/ -AzureADAuthorizationEndPointUri https://noa.awsapps.com/start/ -Credential $livecred
}