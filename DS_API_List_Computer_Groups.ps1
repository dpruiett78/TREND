[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

function create-dsSession{
[string]$server = "10.52.185.3"
[string]$port = "4119"

[string]$userName = "masteradmin"
#[SecureString]$Password = read-host "Enter password" -asSecureString

#$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
#$DSM_PASS = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[string]$DSM_PASS = "Password1"
$GLOBAL:DSM_URI="https://" + $Server + ":" + $port + "/rest/"

$creds = @{
    dsCredentials = @{
        userName = $UserName
        password = $DSM_PASS
        }
}

$AUTH_URI = $DSM_URI + "authentication/login/primary"

$AuthData = ConvertTo-Json -InputObject $creds
#$headers = @{
#"Content-Type"="application/json"
#"api-version"="v1"
#}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", 'application/json')
$headers.Add("api-version", 'v1')

$GLOBAL:sID = Invoke-RestMethod -Uri $AUTH_URI -Method Post -Body $AuthData -Headers $headers

$sID

$sIDString = "?sID=$sID"

$cookie = new-object System.Net.Cookie
$cookie.name = "sID"
$cookie.value =  $sID
$cookie.domain = $Server
$GLOBAL:WebSession=new-object Microsoft.PowerShell.Commands.WebRequestSession
$WebSession.cookies.add($cookie)

return $WebSession
}

function create-relayJson{
    $relayGroupName = "testGroup"
    #$relay = "dsec3as3wq.owfg.com"

    $createRelayGroup = @{
        "CreateRelayGroupRequest" = @{
            "relayGroup" = @{
                "name" = $relayGroupName
            }
        }
    }
    $relayJson = $createRelayGroup | convertto-json
    return $relayJson
}

function list-groupsJson{

    $listgroupsJson = "" | convertto-json
    return $listgroupsJson
}

function create-sessHeader{
    $GLOBAL:headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Accept","application/json")
    $headers.Add("api-version","v1")
}
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
create-dsSession
create-sessHeader
$body = create-relayJson
Write-Host $body
# Simple GET works
Invoke-WebRequest -Uri https://10.52.185.3:4119/rest/relays -WebSession $webSession -Method Get -headers $headers -ContentType 'application/json'

# POST produces the errors
#invoke-RestMethod -Uri https://10.52.185.3:4119/rest/relay-groups -WebSession $webSession -Method Post -Body $body -ContentType 'application/json' -headers $headers

#$GLOBAL.endSession($sID)