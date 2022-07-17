<#
param (
    [Parameter(Mandatory=$true)][string]$manager,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$false)][string]$tenant
)

$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))
#>
$manager = "10.52.184.253"
$user = "MasterAdmin"
$password = "Password1"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.SecurityProtocolType]::Tls11 -bor 
[System.Net.SecurityProtocolType]::Tls12 -bor `   
[System.Net.SecurityProtocolType]::Tls -bor `
[System.Net.SecurityProtocolType]::Ssl3
$Global:DSMSoapService = New-WebServiceProxy -uri "https://$manager/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
$Global:DSM = New-Object DSSOAP.ManagerService
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

$hft = new-object DSSOAP.HostFilterTransport
$hft.type = [DSSOAP.EnumHostFilterType]::ALL_HOSTS
$detailstatus = $DSM.hostDetailRetrieve($hft, [DSSOAP.EnumHostDetailLevel]::LOW, $SID)

$managedCounter=0
$unManagedCounter=0
foreach ($detail in $detailstatus) {if ($detail.overallStatus -like "Unmanaged*") { $unManagedCounter++ } else { $managedCounter++} }
Write-Host "Unmanaged hosts:" $unManagedCounter
Write-Host "Managed hosts:" $managedCounter


$DSM.endSession($SID)