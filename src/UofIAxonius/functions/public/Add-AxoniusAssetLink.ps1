<#
.SYNOPSIS
    Link assets to improve correlation.
.DESCRIPTION
    Link assets to improve correlation.
.PARAMETER AssetType
    Link assets of the selected asset type
.PARAMETER InternalAxonIDs
    Internal IDs of the assets that will be linked together
.EXAMPLE
    Add-AxoniusAssetLink -AssetType 'devices' -InternalAxonIDs 'fcc904542e4efa743b693e0c58a7170m','6e966157b2eb7308cc3dc0b9b6b787dq'
#>
function Add-AxoniusAssetLink{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssetType,
        [Parameter(Mandatory = $true)]
        [string[]]$InternalAxonIDs
    )

    process{

        if ($PSCmdlet.ShouldProcess("[$($InternalAxonIDs)]", "Linking assets")) {

            $RelativeUri = "assets/$($AssetType)/link_assets"

            $RestSplat = @{
                Method      = 'POST'
                RelativeURI = $RelativeUri
                Body        = @{
                    internal_axon_ids = $InternalAxonIDs
                }
            }

            $Response = Invoke-AxoniusRestCall @RestSplat
            $Response
        }
    }
}
