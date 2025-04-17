# Setting My Documents
$parameters = @{
    PSProvider = "FileSystem"
    Root = "C:\Users\<username>\Documents"
    Description = "Maps to My Documents folder."
}
New-PSDrive @parameters
# Set Alias
Set-Alias -Name aws -Value "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
Set-Alias -Name code -Value "C:\Program Files\Microsoft VS Code\Code.exe"
Set-Alias -Name keytool -Value "C:\Program Files\Java\jdk-11.0.7\bin\keytool.exe"
