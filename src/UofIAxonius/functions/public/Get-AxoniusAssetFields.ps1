<#
.Synopsis
    Get all available fields for the provided asset type.
.DESCRIPTION
    Get all available fields for the provided asset type.
.PARAMETER AssetType
    Retrieve assets for the selected asset type. This is required.
.PARAMETER Search
    Search term to filter by. The response will include all the fields that contain the search term.
    For example, if the search term is network, all fields that contain network will be returned
.PARAMETER ExcludeSubfields
    If set to true, the request will return all the fields except subfields.
    For example, the field specific_data.data.network_interfaces will be included in the response but specific_data.data.network_interfaces.ips_preferred will be excluded.
.EXAMPLE
    Get-AxoniusAssetFields -AssetType 'devices'
.EXAMPLE
    Get-AxoniusAssetFields -AssetType 'devices' -Search 'network' -ExcludeSubfields
#>
function Get-AxoniusAssetFields{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AssetType,
        [string]$Search,
        [Alias('exclude_subfields')]
        [switch]$ExcludeSubfields
    )

    process{

        $QueryObjects = @()

        $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object {
            if($_.Key -notlike 'AssetType'){
                $alias = $MyInvocation.MyCommand.Parameters[$_.Key].Aliases[0]
                $paramName = $alias ?? ($_.Key).ToLower()
                $QueryObjects += "$($paramName)=$($_.Value)"
            }
        }

        $QueryString = $QueryObjects -join "&"
        $RelativeUri = "assets/$($AssetType)/fields?$($QueryString)"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
