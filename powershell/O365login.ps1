# Setup O365 login
$runningAzure = Read-Host "Are you connecting to Office 365? (Y/N)"
if($runningAzure -eq "Y"){

$LiveCred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
#Connect-ExchangeOnline -UserPrincipalName <UPN> -ShowProgress $true [-ConnectionUri <URL>] [-AzureADAuthorizationEndPointUri <URL>] [-DelegatedOrganization <String>]
Connect-ExchangeOnline -UserPrincipalName username@domain -BypassMailboxAnchoring -ConnectionUri https://outlook.office.com/powershell-liveid/ -AzureADAuthorizationEndPointUri https://<oauthapps>/start/ -Credential $livecred
}

curl --location --request POST 'https://dragonfly.superasian.net/oapi/v1/jobs' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer OTY2MjZjOWQtMmZiZi00MWYzLWJkZmMtZTQwYjg2MmNlYWZi' \
  --data-raw '{
  "type": "preheat",
  "args": {
    "type": "image",
    "url": "https://index.docker.io/v2/library/alpine/manifests/3.19",
    "scope": "single_seed_peer"
  },
  "scheduler_cluster_ids":[1]
}'