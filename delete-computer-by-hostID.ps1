<#
 
.SYNOPSIS
PowerShell Script to setup objects for remote control of Deep Security Manager via SOAP API.
 
.DESCRIPTION
The ds-api script configures a Manager object for interfacing with the Deep Security Manager SOAP API. It will leave a DSSOAP.ManagerService() Object $DSM and the ManagerSerivce Namespace will be accessible as [DSSOAP].
The Username and Password supplied will be used to authenticate to the Deep Security manager and store a token in $SID.
Log out of the session when finished with $DSM.EndSession($SID).
See the WebService SDK for more information. This script requires the Web Services API to be enabled on Deep Security Manager.


param (
    [Parameter(Mandatory=$true)][string]$manager,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$true)][string]$computer,
    [Parameter(Mandatory=$false)][string]$tenant
)

$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))
#>
$manager = "10.52.185.3:4119"
$user = "MasterAdmin"
$password = "Password1"
$computer = "17"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.SecurityProtocolType]::Tls11 -bor 
[System.Net.SecurityProtocolType]::Tls12 -bor `   
[System.Net.SecurityProtocolType]::Tls -bor `
[System.Net.SecurityProtocolType]::Ssl3
$Global:DSMSoapService = New-WebServiceProxy -uri "https://$manager/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
$Global:DSM = New-Object DSSOAP.ManagerService
$Global:SID
try {
    if (!$tenant) {
        $Global:SID = $DSM.authenticate($user, $password)
        }
    else {
        $Global:SID = $DSM.authenticateTenant($tenant, $user, $password)
        }
}
catch {
    echo "An error occurred during authentication. Verify username and password and try again. `nError returned was: $($_.Exception.Message)"
    exit
}


$HT = $DSM.hostDelete($computer, $Global:SID)

