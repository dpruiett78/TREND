#Manager Version - Use this script to access REST API and receive DSM version
#This is pointed at my manager, change to https://app.deepsecurity.trendmicro.com/rest/managerInfo/version for DSaaS

$url = "https://10.52.184.253/rest/managerInfo/version"
#$url = "https://app.deepsecurity.trendmicro.com/rest/managerInfo/version"

$web = New-Object Net.WebClient

#Set server certificate validation to true, trust all certs
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true } 

#Set security protocol to TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$output = $web.DownloadString($url)

#Set server certificate validation back to null
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
#write output
$output
#Set output to null, so we don't carry forward this result in same session
$output = $null
