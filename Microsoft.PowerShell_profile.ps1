name# Setting My Documents
$parameters = @{
    PSProvider = "FileSystem"
    Root = "C:\Users\<username>\Documents"
    Description = "Maps to My Documents folder."
}
New-PSDrive @parameters
# Set Alias
Set-Alias -Name aws -Value "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
Set-Alias -Name pip3 -Value "C:\Python38\Scripts\pip3.exe"
Set-Alias -Name python3 -Value "C:\Python312\python.exe"
Set-Alias -Name ruby -Value "C:\Ruby26-x64\bin\ruby.exe"
Set-Alias -Name vagrant -Value "C:\HashiCorp\Vagrant\bin\vagrant.exe"
Set-Alias -Name vsm -Value "C:\Users\<username>\visualvm_206\bin\visualvm.exe"
Set-Alias -Name code -Value "C:\Program Files\Microsoft VS Code\Code.exe"
Set-Alias -Name keytool -Value "C:\Program Files\Java\jdk-11.0.7\bin\keytool.exe"
