<#
.SYNOPSIS
  PowerShell Script to query computers and save output to csv.  It will save the script to "C:\DeepSecurity".
.PARAMETER managerIp
  The manager IP or URL
.PARAMETER managerPort
  The port the manager is listening on.  It's usually 4119
.PARAMETER user
  The user that's going to login
.PARAMETER password
  Password of the user
.PARAMETER tenant
  Tenant name
.EXAMPLE
  .\computerReport.ps1 -managerIp 172.16.1.3 -managerPort 80 -user api -password NoVirus1 -tenant "Trend Micro"

param (
    [Parameter(Mandatory=$true)][string]$managerIp,
    [Parameter(Mandatory=$true)][string]$managerPort,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$false)][string]$password,
    [Parameter(Mandatory=$false)][string]$tenant
)
#>
$managerIp = "192.168.1.101"
$user = "MasterAdmin"
$password = "Password1"
$managerPort = "4119"
# Variables
$outputfilepath = "C:\DeepSecurity"
$date = Get-Date -UFormat "%m_%d_%Y"
$stamp = (Get-Date).toString("HH:mm:ss yyyy/MM/dd")
$manager = "${managerIp}:$managerPort"
$file = "C:\DeepSecurity\ComputerReport_$date.csv"
$log = "C:\DeepSecurity\Log\error.log"
$versionMinimum = '4'
# Function to write logs
Function LogWrite {
  Param ([string]$logstring)
  Add-content $log -value "${stamp}: $logstring"
}
# Make sure working directory exists
if (!(Test-Path "C:\DeepSecurity\log")){
    New-Item -ItemType directory -Path "C:\DeepSecurity\Log"
}
# Make sure powershell version is correct
if ($versionMinimum -gt $PSVersionTable.PSVersion) {
  LogWrite "Failed to run. This script requires PowerShell $versionMinimum"
  throw "This script requires PowerShell $versionMinimum"
}
# Prompt for password if one was not provided
#if (!$password) {
#  $passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
#  $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))
#}
# Make sure we can connect to Manager
#try {
#  $test = New-Object System.Net.Sockets.TCPClient -ArgumentList $managerIp,$managerPort;
#}
#catch {
#  LogWrite "Unable to connect to manager - $manager"
#  throw "Unable to connect to manager - $manager"
#}
# Create new soap proxy
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$DSMSoapService = New-WebServiceProxy -uri "https://$manager/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
$DSM = New-Object DSSOAP.ManagerService
$SID
# Authenticate to the DSM
try {
  if (!$tenant) {
       $SID = $DSM.authenticate($user, $password)
   }
   else {
       $SID = $DSM.authenticateTenant($tenant, $user, $password)
   }
}
catch {
   LogWrite "An error occurred during authentication. Verify username and password and try again. `nError returned was: $($_.Exception.Message)"
   throw "An error occurred during authentication. Verify username and password and try again. `nError returned was: $($_.Exception.Message)"
}
# Logic to make sure there is only one file
if (Test-Path $file) {
  LogWrite "Report Already Exists - $file"
}
else {
  # Query all the groups
  $groups = $DSM.hostGroupRetrieveAll($SID);
  # Loop through all groups
  foreach ($a in $groups) {
    # Create an object
    $HFT = New-Object DSSOAP.HostFilterTransport
    $HFT.type = [DSSOAP.EnumHostFilterType]::HOSTS_IN_GROUP
    $HFT.hostGroupID = $a.id
    # Retrieve specific information from the object
    $cRetrieve = $DSM.hostDetailRetrieve($HFT, [DSSOAP.EnumHostDetailLevel]::HIGH, $SID) | Select-Object overallVersion, platform
    # Write to file
    $platformList = $cRetrieve | Group-Object -Property platform 
    foreach ($b in $platformList.Name) {
      $test = $cRetrieve | Select-Object overallVersion | Group-Object -Property overallVersion
      $prop = @{
        Platform = $b
        Version = $test.Name
        Count = $test.Count
      }
      #$prop.Count
      $results = New-Object psobject -Property $prop 
      $results #| Export-Csv 'Results.csv' -NoTypeInformation -Append
    }
  }
}
# End the session
$DSM.endSession($SID)