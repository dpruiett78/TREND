<#param (
    [Parameter(Mandatory=$true, HelpMessage="FQDN and port for Deep Security Manager; ex dsm.example.com:443--")][string]$manager,
    [Parameter(Mandatory=$true, HelpMessage="DeepSecurity Manager Username with api access--")][string]$user,
    [Parameter(Mandatory=$true, HelpMessage="Start Date for search in format mm/dd/yyyy; ex 12/31/1970--")][string]$fromDate,
    [Parameter(Mandatory=$true, HelpMessage="End Date for search in format mm/dd/yyyy; ex 12/31/1970--")][string]$toDate,
    [Parameter(Mandatory=$true, HelpMessage="Filename for csv output; if existing data will be appended--")][string]$filename,
    [Parameter(Mandatory=$false)][string]$tenant
)

$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))
#>
$manager = "10.52.184.253"
$user = "MasterAdmin"
$password = "Password1"
$fromDate = "04/01/2018"
$toDate = "06/20/2020"
$tenant = ""
$filename = "c:\PowerShellPrograms\computerEvents.xlsx"
$filename2 = "c:\PowerShellPrograms\computerEventsShort.xlsx"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.SecurityProtocolType]::Tls11 -bor 
[System.Net.SecurityProtocolType]::Tls12 -bor `   
[System.Net.SecurityProtocolType]::Tls -bor `
[System.Net.SecurityProtocolType]::Ssl3
$DSMSoapService = New-WebServiceProxy -uri "https://10.52.184.253:443/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
$DSM = New-Object DSSOAP.ManagerService
$SID = ""
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

$hft = New-Object DSSOAP.HostFilterTransport
$hft.type = [DSSOAP.EnumHostFilterType]::ALL_HOSTS
$tft = New-Object DSSOAP.TimeFilterTransport
$tft.rangeFrom = [datetime]"$fromDate"
$tft.rangeTo = [datetime]"$toDate"
$tft.type = [DSSOAP.EnumTimeFilterType]::CUSTOM_RANGE
$idft = New-Object DSSOAP.IdFilterTransport2
$idft.operator = [DSSOAP.EnumOperator]::EQUAL


$shortdesc = $DSM.systemEventRetrieveShortDescription($tft, $hft, $null, $false, $SID)


foreach ($evt in $shortdesc.systemEvents)

{
    #if ($evt.eventID -eq 250)
    #{
        #Write-Host($evt.event,$evt.eventID) -Separator ","
        $idft.id = $evt.systemEventID
        $fullevents = $DSM.systemEventRetrieve2($tft, $hft, $idft, $false, $SID)
        #Write-Host($fullevents.systemEvents[0].event, $fullevents.systemEvents[0].eventID, $fullevents.systemEvents[0].target, $fullevents.systemEvents[0].description) -Separator ","
        $fullevents.systemEvents | Export-Excel $filename -Append
    #}
}


$DSMSoapService.endSession($SID)