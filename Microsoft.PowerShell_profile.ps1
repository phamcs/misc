name# Setting My Documents
$parameters = @{
    Name = "MyDocs"
    PSProvider = "FileSystem"
    Root = "C:\Users\<username>\Documents"
    Description = "Maps to My Documents folder."
}
New-PSDrive @parameters
# Set Alias
Set-Alias -Name aws -Value "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
Set-Alias -Name pip3 -Value "C:\Python38\Scripts\pip3.exe"
Set-Alias -Name python3 -Value "C:\Python38\python.exe"
Set-Alias -Name python2 -Value "C:\Python27\python.exe"
Set-Alias -Name pip2 -Value "C:\Python27\Scripts\pip2.exe"
Set-Alias -Name ruby -Value "C:\Ruby26-x64\bin\ruby.exe"
Set-Alias -Name vagrant -Value "C:\HashiCorp\Vagrant\bin\vagrant.exe"
Set-Alias -Name vsm -Value "C:\Users\<username>\visualvm_206\bin\visualvm.exe"
Set-Alias -Name pycharm -Value "C:\Program Files\JetBrains\PyCharm 2020.1.2\bin\pycharm64.exe"
Set-Alias -Name keytool -Value "C:\Program Files\Java\jdk-11.0.7\bin\keytool.exe"
