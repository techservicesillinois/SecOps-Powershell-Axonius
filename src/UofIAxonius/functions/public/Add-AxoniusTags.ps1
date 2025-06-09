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
.PARAMETER BatchSize
    Maximum number of assets to process in a single API call.
.EXAMPLE
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag' -InternalAxonIDs 'fcc904542e4efa743b693e0c58a7170e','6e966157b2eb7308cc3dc0b9b6b787de'
.EXAMPLE
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag 1','Test Tag 2' -InternalAxonIDs 'fcc904542e4efa743b693e0c58a7170e'
.EXAMPLE
    Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag' -InternalAxonIDs $LargeArrayOfIDs -BatchSize 5000
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
        [string[]]$InternalAxonIDs,
        [int]$BatchSize,
        [bool]$DiscardOutput = $false
    )

    process{
        if ($PSCmdlet.ShouldProcess("[$($Tags -join ', ')] for [$($InternalAxonIDs.count)] assets", "Add Tags")) {
            $RelativeUri = "assets/$($AssetType)/add_tags"

            if (-not ($PSBoundParameters.ContainsKey('BatchSize'))) {
                [int]$BatchSize = ($InternalAxonIDs.Count + 1)
            }

            # Split processing into batches if needed
            for ($i = 0; $i -lt $InternalAxonIDs.Count; $i += $BatchSize) {
                # Calculate the size of the current batch
                $CurrentBatchSize = [Math]::Min($BatchSize, $InternalAxonIDs.Count - $i)

                # Get the subset of IDs for this batch
                $BatchIDs = $InternalAxonIDs[$i..($i + $CurrentBatchSize - 1)]

                # Log batch information if verbose
                Write-Verbose "Processing batch $([Math]::Floor($i / $BatchSize) + 1) with $($BatchIDs.Count) IDs (from index $i to $($i + $CurrentBatchSize - 1))"

                $RestSplat = @{
                    Method      = 'POST'
                    RelativeURI = $RelativeUri
                    Body        = @{
                        'tags' = $Tags
                        'entities' = @{
                            'internal_axon_ids' = $BatchIDs
                        }
                    }
                }

                # Make the API call for this batch
                if ($DiscardOutput) {
                    [void](Invoke-AxoniusRestCall @RestSplat)
                }
                else {
                    $Response = Invoke-AxoniusRestCall @RestSplat
                    $Response
                }
            }
        }
    }
}
