Param (
  [Parameter(Mandatory = $true)]
  [string]
  $azureUsername,

  [string]
  $azurePassword,

  [string]
  $azureTenantID,

  [string]
  $azureSubscriptionID,

  [string]
  $odlId,
    
  [string]
  $deploymentId
)

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append

[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 

CreateLabFilesDirectory;

#download the solliance pacakage
$WebClient = New-Object System.Net.WebClient;
$WebClient.DownloadFile("https://raw.githubusercontent.com/solliancenet/common-workshop/main/scripts/common.ps1","C:\LabFiles\common.ps1")

#run the solliance package
. C:\LabFiles\Common.ps1

DisableInternetExplorerESC

EnableIEFileDownload

InstallAzPowerShellModule

InstallNotepadPP

$ext = @("ms-vscode.azurecli")
InstallVisualStudioCode $ext

InstallDotNetCore "3.1"

InstallDotNet5;

InstallDocker;

InstallGit;

InstallChocolaty

InstallFiddler;

InstallPostman;

InstallSmtp4Dev;

InstallAzureCli;

$vsVersion = "community"
InstallVisualStudio $vsVersion;

UpdateVisualStudio $vsVersion;

AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Workload.Azure" $true;
AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Workload.NetCoreTools" $true;
AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Workload.NetWeb" $true;
AddVisualStudioWorkload $vsVersion "Component.GitHub.VisualStudio" $true;
AddVisualStudioWorkload $vsVersion "Microsoft.VisualStudio.Component.Git" $true;

cd "c:\labfiles";

CreateCredFile $azureUsername $azurePassword $azureTenantID $azureSubscriptionID $deploymentId $odlId

. C:\LabFiles\AzureCreds.ps1

$userName = $AzureUserName                # READ FROM FILE
$password = $AzurePassword                # READ FROM FILE
$clientId = $TokenGeneratorClientId       # READ FROM FILE

Uninstall-AzureRm

$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $userName, $SecurePassword

Connect-AzAccount -Credential $cred | Out-Null
         
#install sql server cmdlets
Install-Module -Name SqlServer

cd "c:\labfiles";

git clone https://github.com/ardalis/CleanArchitecture

Rename-Item -Path "c:\LabFiles\CleanArchitecture\CleanArchitecture.sln" -NewName "DDDGuestbook.sln"

git clone https://github.com/ardalis/eshoponweb

sleep 20

Stop-Transcript

Restart-Computer -Force

return 0;