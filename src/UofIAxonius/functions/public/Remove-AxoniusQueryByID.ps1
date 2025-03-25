<#
.SYNOPSIS
    Delete the saved query specified by ID.
.DESCRIPTION
    Delete the saved query specified by ID.
.PARAMETER QueryID
    The ID of the saved query.
.EXAMPLE
    Remove-AxoniusQueryByID -QueryID '6708507f3490af2b8a3bbc2b'
#>
function Remove-AxoniusQueryByID{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$QueryID
    )

    process{
        if ($PSCmdlet.ShouldProcess("[$($QueryID)]", "Remove Query")) {
            $RelativeUri = "queries/$($QueryID)"

            $RestSplat = @{
                Method      = 'DELETE'
                RelativeURI = $RelativeUri
            }

            $Response = Invoke-AxoniusRestCall @RestSplat
            $Response
        }
    }
}
