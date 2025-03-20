<#
.SYNOPSIS
    Get details of a saved query specified by ID.
.DESCRIPTION
    Get details of a saved query specified by ID.
.PARAMETER QueryID
    The ID of the saved query.
.EXAMPLE
    Get-AxoniusQueryByID -QueryID '65ca7ef6235104a51081d741'
#>
function Get-AxoniusQueryByID{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('query_id')]
        [string]$QueryID
    )

    process{

        $RelativeUri = "queries/$($QueryID)"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
