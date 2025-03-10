<#
.SYNOPSIS
    Get assets count in the system.
.DESCRIPTION
    Retrieves count of assets based on the specified filters.
.PARAMETER AssetType
    Retrieve assets for the selected asset type. This is required.
.PARAMETER SavedQueryID
    The ID of a saved query used to identify what assets to include in the response. Cannot be used with SavedQueryName or Query.
.PARAMETER SavedQueryName
    The name of a saved query used to identify what assets to include in the response. If a name is provided, it will be looked up and converted to an ID automatically. Cannot be used with SavedQueryId or Query.
.PARAMETER Query
    An AQL statement to filter which assets are returned. Example: ("specific_data.data.hostname" == regex("nginx", "i")). Cannot be used with SavedQueryName or SavedQueryId.
.PARAMETER History
    A historical snapshot date to query against in YYYY-MM-DD format (e.g., 2024-10-15).
.EXAMPLE
    Get-AxoniusAssetCount -AssetType 'vulnerabilities'
.EXAMPLE
    Get-AxoniusAssetCount -AssetType 'devices' -SavedQueryID '663a416c55acdf1150bc38e4'
.EXAMPLE
    Get-AxoniusAssetCount -AssetType 'devices' -Query "(`"specific_data.data.hostname_preferred`" == regex(`"TEST`", `"i`"))"
#>
function Get-AxoniusAssetCount{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AssetType,
        [Alias('saved_query_id')]
        [string]$SavedQueryID,
        [Alias('saved_query_name')]
        [string]$SavedQueryName,
        [string]$Query,
        [string]$History
    )

    process{

        $RelativeUri = "assets/$($AssetType)/count"

        $RestSplat = @{
            Method      = 'POST'
            RelativeURI = $RelativeUri
            Body        = @{
            }
        }

        #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
        [String[]]$Exclusions = ('AssetType')
        $PSBoundParameters.Keys | Where-Object -FilterScript {($_ -notin $Exclusions) -and $_} | ForEach-Object -Process {
            if($MyInvocation.MyCommand.Parameters[$_].Aliases[0]){
                [String]$APIKeyNames = $MyInvocation.MyCommand.Parameters[$_].Aliases[0]
                $RestSplat.Body.$APIKeyNames = $PSBoundParameters[$_]
            }
            else {
                $LowerKey = $_.ToLower()
                $RestSplat.Body.$LowerKey = $PSBoundParameters[$_]
            }
        }
        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
