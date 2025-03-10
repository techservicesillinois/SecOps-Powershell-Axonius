<#
.SYNOPSIS
    Unlink assets to improve correlation.
.DESCRIPTION
    Unlink assets to improve correlation.
.PARAMETER AssetType
    Unlink assets of the selected asset type
.PARAMETER InternalAxonIDs
    Internal IDs of the assets that will be unlinked
.EXAMPLE
    Remove-AxoniusAssetLink -AssetType 'devices' -InternalAxonIDs 'fcc904542e4efa743b693e0c58a7170m','6e966157b2eb7308cc3dc0b9b6b787dq'
#>
function Remove-AxoniusAssetLink{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssetType,
        [Parameter(Mandatory = $true)]
        [string[]]$InternalAxonIDs
    )

    process{

        if ($PSCmdlet.ShouldProcess("[$($InternalAxonIDs)]", "Unlinking assets")) {

            $RelativeUri = "assets/$($AssetType)/unlink_assets"

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
