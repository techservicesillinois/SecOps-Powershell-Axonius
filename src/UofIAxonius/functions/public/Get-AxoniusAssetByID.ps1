<#
.SYNOPSIS
    Retrieve an asset by its internal_axon_id.
.DESCRIPTION
    This function allows you to retrieve an asset's complete details using its internal_axon_id.
    You can also query historical snapshots and specify whether to return additional details for complex fields.
.PARAMETER AssetType
    The type of asset to retrieve (e.g., "devices"). This is required.
.PARAMETER InternalAxonId
    The internal_axon_id of the asset you want to retrieve. This is required.
.PARAMETER History
    A historical snapshot date to query against in YYYY-MM-DD format (e.g., 2023-10-15). This is optional.
.PARAMETER ReturnEmptyDetails
    If set to true, will populate null values for _details fields that are missing values from specific adapters. Defaults to false.
.PARAMETER ReturnComplexFieldsData
    If set to true, returns complex fields table data (e.g., nested objects like specific_data.data.network_interfaces). Defaults to true.
.EXAMPLE
    Get-AxoniusAssetByID -AssetType 'devices' -InternalAxonID 'fcc904542e4efa743b693e0c58a7170e'
.EXAMPLE
    Get-AxoniusAssetByID -AssetType 'devices' -InternalAxonID 'fcc904542e4efa743b693e0c58a7170e' -History '2024-10-15' -ReturnEmptyDetails $true -ReturnComplexFieldsData $false
#>
function Get-AxoniusAssetByID{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssetType,
        [Parameter(Mandatory = $true)]
        [string]$InternalAxonId,
        [string]$History,
        [Alias('return_empty_details')]
        [bool]$ReturnEmptyDetails = $false,
        [Alias('return_complex_fields_data')]
        [bool]$ReturnComplexFieldsData = $true
    )

    process{

        $QueryObjects = @()

        $ExcludedKeys = @('AssetType', 'InternalAxonId')

        $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object {
            if($_.Key -notin $ExcludedKeys){
                $alias = $MyInvocation.MyCommand.Parameters[$_.Key].Aliases[0]
                $paramName = $alias ?? $_.Key.ToLower()
                $QueryObjects += "$($paramName)=$($_.Value)"
            }
        }

        $QueryString = $QueryObjects -join "&"
        $RelativeUri = "assets/$($AssetType)/$($InternalAxonId)?$($QueryString)"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
