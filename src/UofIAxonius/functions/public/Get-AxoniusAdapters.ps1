<#
.Synopsis
    Get details of all adapters in the system.
.DESCRIPTION
    Get details of all adapters in the system.
.PARAMETER IncludeConnectionDetails
    Defaults to false. If set to true, will include connection details for each adapter.
.EXAMPLE
    Get-AxoniusAdapters
.EXAMPLE
    Get-AxoniusAdapters -IncludeConnectionDetails $true
#>
function Get-AxoniusAdapters{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Alias('include_connection_details')]
        [bool]$IncludeConnectionDetails
    )

    process{

        $QueryObjects = @()

        $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object {
            if($_.Key -notin $ExcludedKeys){
                $alias = $MyInvocation.MyCommand.Parameters[$_.Key].Aliases[0]
                $paramName = $alias ?? $_.Key.ToLower()
                $QueryObjects += "$($paramName)=$($_.Value)"
            }
        }

        $QueryString = $QueryObjects -join "&"
        $RelativeUri = "adapters?$($QueryString)"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
