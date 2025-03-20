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
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag' -InternalAxonIDs 'fcc904542e4efa743b693e0c58a7170e','6e966157b2eb7308cc3dc0b9b6b787de'
.EXAMPLE
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag 1','Test Tag 2' -InternalAxonIDs 'fcc904542e4efa743b693e0c58a7170e'
#>
function Add-AxoniusTags{
    [CmdletBinding(SupportsShouldProcess)]
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

        if ($PSCmdlet.ShouldProcess("[$($Tags -join ', ')] for [$($InternalAxonIDs.count)] assets", "Add Tags")) {

            $RelativeUri = "assets/$($AssetType)/add_tags"

            $RestSplat = @{
                Method      = 'POST'
                RelativeURI = $RelativeUri
                Body        = @{
                    'tags' = $Tags
                    'entities' = @{
                        'internal_axon_ids' = $InternalAxonIDs
                    }
                }
            }

            $Response = Invoke-AxoniusRestCall @RestSplat
            $Response
        }
    }
}
