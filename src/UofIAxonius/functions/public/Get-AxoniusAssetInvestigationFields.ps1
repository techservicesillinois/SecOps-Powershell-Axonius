<#
.SYNOPSIS
    Get all available asset investigation fields for all assets of the selected asset type.
.DESCRIPTION
    Get all available asset investigation fields for all assets of the selected asset type.
    Use this endpoint first when using the “fields” field in the “Get Asset Investigation” endpoint.
.PARAMETER AssetType
    The type of asset to retrieve (e.g., "devices"). This is required.
.EXAMPLE
    Get-AxoniusAssetInvestigationFields -AssetType 'devices'
#>
function Get-AxoniusAssetInvestigationFields{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssetType
    )

    process{

        $RelativeUri = "assets/$($AssetType)/asset_investigation/fields"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
