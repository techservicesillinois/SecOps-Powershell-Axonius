<#
.SYNOPSIS
    Get details of all assets that match the provided filters.
.DESCRIPTION
    Retrieves asset details based on the specified filters, allowing for querying, pagination, and metadata inclusion.
.PARAMETER AssetType
    Retrieve assets for the selected asset type.
.PARAMETER IncludeMetadata
    Defaults to true. When true, returns metadata such as item count and paging information. Useful for large data sets.
.PARAMETER SavedQueryID
    The ID of a saved query used to identify what assets to include in the response. Cannot be used with SavedQueryName or Query.
.PARAMETER SavedQueryName
    The name of a saved query used to identify what assets to include in the response. If a name is provided, it will be looked up and converted to an ID automatically. Cannot be used with SavedQueryId or Query.
.PARAMETER Query
    An AQL statement to filter which assets are returned. Example: ("specific_data.data.hostname" == regex("nginx", "i")). Cannot be used with SavedQueryName or SavedQueryId.
.PARAMETER History
    A historical snapshot date to query against in YYYY-MM-DD format (e.g., 2023-10-15).
.PARAMETER Page
    A paging object used to divide the result set into discrete subsets of data.
.PARAMETER Fields
    A list of field names in dotted notation to be returned in the response. Example: specific_data.data.name.
.PARAMETER UseCacheEntry
    Defaults to true. Uses cached results if they exist. Cache settings reside in Settings -> Data -> Cache and Performance.
.PARAMETER IncludeDetails
    Defaults to true. Includes a non-aggregated list of values for each field returned. A new field suffixed with "_details: will contain the non-aggregated list.
.EXAMPLE
    Get-AxoniusAssets -AssetType 'vulnerabilities'
.EXAMPLE
    Get-AxoniusAssets -AssetType 'devices' -SavedQueryID '663a416c55acdf1150bc38e4' -Fields 'specific_data.data.public_ips','specific_data.data.network_interfaces.ips_v4_preferred'
.EXAMPLE
    Get-AxoniusAssets -AssetType 'devices' -Query "(`"specific_data.data.hostname_preferred`" == regex(`"TEST`", `"i`"))"
#>
function Get-AxoniusAssets{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AssetType,
        [Alias('include_metadata')]
        [bool]$IncludeMetadata = $true,
        [Alias('saved_query_id')]
        [string]$SavedQueryID,
        [Alias('saved_query_name')]
        [string]$SavedQueryName,
        [string]$Query,
        [string]$History,
        [PSCustomObject]$Page,
        [string[]]$Fields,
        [Alias('use_cache_entry')]
        [bool]$UseCacheEntry = $true,
        [Alias('include_details')]
        [bool]$IncludeDetails = $true
    )

    process{

        $RelativeUri = "assets/$($AssetType)"

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
