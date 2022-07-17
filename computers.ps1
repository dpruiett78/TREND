#param (
#    [Parameter(Mandatory=$true)][string]$manager,
#    [Parameter(Mandatory=$true)][string]$user,
#    [Parameter(Mandatory=$false)][string]$tenant
#)

#$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
#$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))
$manager = "10.52.185.38"
$user = "MasterAdmin"
$password = "Password1"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.SecurityProtocolType]::Tls11 -bor 
[System.Net.SecurityProtocolType]::Tls12 -bor `   
[System.Net.SecurityProtocolType]::Tls -bor `
[System.Net.SecurityProtocolType]::Ssl3
$Global:DSMSoapService = New-WebServiceProxy -uri "https://10.52.184.253:443/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
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
$status = $DSM.hostDetailRetrieve($hft,"High", $SID)
#$status
$status | Select-Object "id", "name", "displayName", "overallStatus", "overallVersion", "lastIPUsed", "overallLastSuccessfulCommunication", "description", "platform", "hostType", "virtualName", "virtualUuid", "securityProfileName", "overallAntiMalwareStatus", "overallWebReputationStatus", "overallFirewallStatus", "overallDpiStatus", "overallIntegrityMonitoringStatus", "overallLogInspectionStatus", "overallLastRecommendationScan", "overallLastSuccessfulUpdate", "lastAnitMalwareScheduledScan", "hostLight", "cloudObjectInstanceId", "antiMalwareSmartScanPatternVersion" | Export-Csv -Path c:\PowerShellPrograms\Computers.csv -Encoding ascii -NoTypeInformation
Foreach ($computer in $status)
   {
   $computer
   }
$status | Export-Csv 'computers.csv' -NoTypeInformation -Append
$DSM.endSession($SID)