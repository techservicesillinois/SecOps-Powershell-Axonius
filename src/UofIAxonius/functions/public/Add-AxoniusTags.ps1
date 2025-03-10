<#
.SYNOPSIS
    Add tags to assets.
.DESCRIPTION
    Add tags to assets.
.PARAMETER AssetType
    Retrieve assets for the selected asset type. This is required.
.PARAMETER Tags
    A list of asset tags to apply. This is required.
.PARAMETER InternalAxonIDs
    A list of Internal IDs of the assets that tags will be applied to
.EXAMPLE
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag' -InternalAxonIDs '5f5e4b3c55acdf1150bc38e4','5f5e4b3c55acdf1150bc38e5'
.EXAMPLE
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag 1','Test Tag 2' -InternalAxonIDs '5f5e4b3c55acdf1150bc38e4'
#>
function Add-AxoniusTags{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssetType,
        [Parameter(Mandatory = $true)]
        [string[]]$Tags,
        [Parameter(Mandatory = $true)]
        [string[]]$InternalAxonIDs
    )

    process{

        $RelativeUri = "assets/$($AssetType)/add_tags"

        $RestSplat = @{
            Method      = 'POST'
            RelativeURI = $RelativeUri
            Body        = @{
                tags = $Tags
                internal_axon_ids = $InternalAxonIDs
            }
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
