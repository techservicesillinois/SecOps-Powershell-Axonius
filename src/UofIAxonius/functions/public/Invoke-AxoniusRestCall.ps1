<#
.Synopsis
    Makes a REST method call on the given relative URI for Axonius. Utilizes credentials created with New-AxoniusSession.
.DESCRIPTION
    Makes a REST method call on the given relative URI for Feroot. Utilizes credentials created with New-AxoniusSession.
.PARAMETER RelativeURI
    The relativeURI you wish to make a call to. Ex: "assets/devices"
.PARAMETER Method
    Method of the REST call Ex: POST
.PARAMETER Body
    Body of the REST call as a hashtable
.EXAMPLE
    Invoke-AxoniusRestCall -RelativeURI "queries" -Method 'GET'
#>
function Invoke-AxoniusRestCall {
    [CmdletBinding(DefaultParameterSetName='Body')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$RelativeURI,
        [Parameter(Mandatory=$true)]
        [String]$Method,
        [hashtable]$Body
    )

    begin {
        if($null -eq $Script:Session){
            Write-Verbose -Message 'No Axonius session established. Please provide API-Key and API-Secret as username and password.'
            New-AxoniusSession
        }
    }

    process {

        if ($RelativeURI.StartsWith('/')){
            $RelativeURI.Substring(1)
        }

        $IVRSplat = @{
            Headers = @{
                'Content-Type' = 'application/json'
                'api-key' = $Script:Session.UserName
                'api-secret' = $Script:Session.GetNetworkCredential().Password
            }
            Method = $Method
            URI = "$($Script:Settings.BaseURI)$RelativeURI"
        }

        if($Body){
            $IVRSplat.Add('Body', ($Body | ConvertTo-Json))
        }
        #Retry parameters only available in Powershell 7.1+, so we use a try/catch to retry calls once to compensate for short periods where the Axonius API is unreachable
        try{

            Invoke-RestMethod @IVRSplat
            $Script:APICallCount++
        }
        catch{
            Start-Sleep -Seconds 4
            Invoke-RestMethod @IVRSplat
            $Script:APICallCount++
        }
    }

    end {
    }
}
