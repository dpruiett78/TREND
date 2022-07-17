
param (
    [Parameter(Mandatory=$true)][string]$manager,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$false)][string]$tenant
)

$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))

[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
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
$currenttime = Get-Date -Format "yyyy-MM-dd-hhmm"
$outfile = ".\AgentOverallStatus-$currenttime.csv"

"Name;Platform;Policy;Status;Agent Version;Anti-Malware Status;Scan Pattern Version;Web Reputation Status;Firewall Status;Intrusion Prevention Status;Integrity Monitoring Status;Log Inspection Status;Last Update;Last Communication" | Out-File $outfile -Append  
foreach ($detail in $detailstatus) {
    $detail.name+";"+$detail.platform+";"+$detail.securityProfileName+";"+$detail.overallStatus+";"+$detail.overallVersion+";"+$detail.overallAntiMalwareStatus+";"+$detail.antiMalwareSmartScanPatternVersion+";"+$detail.overallWebReputationStatus+";"+$detail.overallFirewallStatus+";"+$detail.overallDpiStatus+";"+$detail.overallIntegrityMonitoringStatus+";"+$detail.overallLogInspectionStatus+";"+$detail.overallLastSuccessfulUpdate+";"+$detail.overallLastSuccessfulCommunication | Out-File $outfile -Append    
}

Write-Host "The file $outfile is ready"

$DSM.endSession($SID)