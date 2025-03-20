<#
.Synopsis
    Get details for all folders of saved queries.
.DESCRIPTION
    Get details for all folders of saved queries.
.EXAMPLE
    Get-AxoniusQueryFolders
#>
function Get-AxoniusQueryFolders{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
    )

    process{

        $RelativeUri = "queries/folders"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
