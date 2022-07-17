<#
.SYNOPSIS
PowerShell Script to query status of a Deep Security Relay.

param (
    [Parameter(Mandatory=$true)][string]$manager,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$true)][string]$hostname,
    [ValidateSet("true","false","status")][string]$relaystate = "status",
    [Parameter(Mandatory=$false)][string]$tenant
)
$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))
#>
$manager = "10.52.185.3"
$user = "MasterAdmin"
$password = "Password1"
$hostname = "10.52.184.193"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.SecurityProtocolType]::Tls11 -bor 
[System.Net.SecurityProtocolType]::Tls12 -bor `   
[System.Net.SecurityProtocolType]::Tls -bor `
[System.Net.SecurityProtocolType]::Ssl3
$DSMSoapService = New-WebServiceProxy -uri "https://10.52.185.3:4119/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
$DSM = New-Object DSSOAP.ManagerService
$SID
try {
    if (!$tenant) {
        $SID = $DSM.authenticate($user, $password)
        }
    else {
        $SID = $DSM.authenticateTenant($tenant, $user, $password)
        }
}
catch {
    echo "An error occurred during authentication. Verify username and password and try again. `nError returned was: $($_.Exception.Message)"
    exit
}
try {
    $HT = $DSM.hostRetrieveByName($hostname,$SID)
    $hostID = $HT.ID
    $HTA = $DSM.hostDelete($hostID, $SID)
}

catch {
    echo "Hostname $($hostname) was not found. Note that hostnames are case sensitive. `nError returned from DSM was: $($_.Exception.Message)"
}
$DSMSoapService.endSession($SID)