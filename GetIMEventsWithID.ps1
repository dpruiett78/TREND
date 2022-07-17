# Run this script on powershell as administartor on test system
#.\GetIMEvents.ps1 <dsm:PORT> <USERNAME> <Host as Dispalyed on DSM >  <output CSV file> [tenant optional]
# e.g.  .\GetIMEvents.ps1 localhost:4119 masteradmin localhost  test.csv
param (
    [Parameter(Mandatory=$true, HelpMessage="FQDN and port for Deep Security Manager; ex dsm.example.com:443--")][string]$manager,
    [Parameter(Mandatory=$true, HelpMessage="DeepSecurity Manager Username with api access--")][string]$user,
    [Parameter(Mandatory=$true, HelpMessage="HostID")][string]$hid,
    [Parameter(Mandatory=$true, HelpMessage="Filename for csv output; if existing data will be appended--")][string]$filename,
    [Parameter(Mandatory=$false)][string]$tenant
)

$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))

[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
$DSMSoapService = New-WebServiceProxy -uri "https://$manager/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
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
$host1 = New-Object DSSOAP.HostTransport
Write-Host $hostName
#$host1=$DSM.hostRetrieveByName($hostName,$SID)
$host1=$DSM.hostRetrieve($hid,$SID)
$hft = New-Object DSSOAP.HostFilterTransport
#$hft.type = [DSSOAP.EnumHostFilterType]::ALL_HOSTS
$hft.type = [DSSOAP.EnumHostFilterType]::SPECIFIC_HOST
$hft.hostID=$host1.ID
Write-Host "checking for hosts ==>"  $host1.name
$tft = New-Object DSSOAP.TimeFilterTransport
$tft.rangeFrom =  (Get-Date).ToUniversalTime()
$tft.rangeTo = (Get-Date).ToUniversalTime().AddMinutes(10)
$tft.type = [DSSOAP.EnumTimeFilterType]::CUSTOM_RANGE
$idft = New-Object DSSOAP.IdFilterTransport2
$idft.operator = [DSSOAP.EnumOperator]::EQUAL
$flag=0
$dsaDiag="C:\Program Files\Trend Micro\Deep Security Agent\dsa_control.cmd"

#$shortdesc = $DSM.systemEventRetrieveShortDescription($tft, $hft, $null, $false, $SID)

$imevents = $DSM.integrityEventRetrieve2($tft, $hft, $null, $SID) 
$imevents.integrityEvents | export-csv -Path $filename -Append


while($flag -eq 0){
#echo "#test" >> C:\Windows\System32\drivers\etc\hosts
Write-Host "Checking events"

$tft.rangeTo = (Get-Date).ToUniversalTime().AddMinutes(10)
Start-Sleep -s 300  #5 min sleep
$imevents = $DSM.integrityEventRetrieve2($tft, $hft, $null, $SID) 
foreach ($evt in $imevents.integrityEvents)
{ 
    if ($evt.key.Contains(("N/A")))  #if($evt.user.Contains(("N/A"))) 
     {   Write-Host ("sucess Start creating DSA diag") 
        & $dsaDiag -d
        New-Item "TREND\dsalog" -type directory -force 
        copy 'C:\ProgramData\Trend Micro\Deep Security Agent\diag\*.log'  "TREND\dsalog"
        copy "C:\ProgramData\Trend Micro\Deep Security Agent\im\*.db"  "TREND\dsalog"
        $flag=1
        break
        Write-Host ("sucess2") 
    }
}
 
}

$imevents.integrityEvents | export-csv -Path $filename -Append

Write-Host ("Copy dsa diag")
sleep 600  #wait for 5 min for diag pkg geneartion
copy "C:\ProgramData\Trend Micro\Deep Security Agent\diag\*.zip" "TREND\dsalog"
 


$DSMSoapService.endSession($SID)