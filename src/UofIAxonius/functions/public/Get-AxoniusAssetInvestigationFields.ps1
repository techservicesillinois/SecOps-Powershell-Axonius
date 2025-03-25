<#
.SYNOPSIS
    Get all available asset investigation fields for all assets of the selected asset type. Use this endpoint first
.DESCRIPTION
    Get all available asset investigation fields for all assets of the selected asset type. Use this endpoint first
.PARAMETER AssetType
    Retrieve assets for the selected asset type. This is required.
.EXAMPLE
    Get-AxoniusAssetInvestigationFields -AssetType 'devices'
#>
function Get-AxoniusAssetInvestigationFields{
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
