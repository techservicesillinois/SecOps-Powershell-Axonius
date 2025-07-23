<#
.SYNOPSIS
    Get fetch history details from the system.
.DESCRIPTION
    Retrieves fetch history records based on filters such as adapter names, connection IDs, statuses, and time range. Supports sorting and pagination.
.PARAMETER Sort
    A field name to sort the results by. Prefix with "-" for descending and "+" for ascending sort.
    Example: -last_fetch_time
.PARAMETER Page
    A pscustomobject used to divide the result set into discrete subsets of data. The object should include a limit and/or offset property.
    Example: $Page = [pscustomobject]@{'limit'=100; 'offset'=0}
.PARAMETER Adapters
    An array of adapter names to filter the fetch history for specific adapters only.
    Example: @('aws_adapter', 'azure_adapter')
.PARAMETER ConnectionIds
    An array of connection IDs to filter the fetch history for specific connections only.
    Example: @('5fdb23a0af123c0012a3e567', '5fdc9ba3cf6723001956d911')
.PARAMETER ExcludeRealtime
    Boolean flag to exclude real-time fetches. Defaults to false.
.PARAMETER Statuses
    An array of fetch statuses to filter results.
    Example: @('success', 'failure')
.PARAMETER TimeRange
    A hashtable or object representing a time range with optional properties such as `date_from`, `date_to`, `count`, `type`, `relative_type`, and `unit`.
    Example:
        @{ date_from = "2025-06-01T00:00:00Z"; date_to = "2025-06-30T23:59:59Z"; type = "absolute" }
.EXAMPLE
    Get-AxoniusFetchHistory -Sort "-last_fetch_time" -ExcludeRealtime $true -Statuses @("success", "partial")
.EXAMPLE
    Get-AxoniusFetchHistory -Adapters @("aws_adapter") -TimeRange @{ type = "absolute"; date_from = "2025-06-01T00:00:00Z"; date_to = "2025-06-15T23:59:59Z" }
#>

function Get-AxoniusFetchHistory {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [string]$Sort,
        [PSCustomObject]$Page,
        [string[]]$Adapters,
        [Alias('connection_ids')]
        [string[]]$ConnectionIds,
        [Alias('exclude_realtime')]
        [bool]$ExcludeRealtime = $false,
        [string[]]$Statuses,
        [Alias('time_range')]
        [hashtable]$TimeRange
    )
    process {

        $RelativeUri = "adapters/fetch_history"

        # Format ISO timestamps for time_range.date_from and time_range.date_to if they exist
        if ($TimeRange) {
            if ($TimeRange["date_from"] -as [datetime]) {
                $TimeRange["date_from"] = ([datetime]$TimeRange["date_from"]).ToString("yyyy-MM-ddTHH:mm:ssZ")
            }
            if ($TimeRange["date_to"] -as [datetime]) {
                $TimeRange["date_to"] = ([datetime]$TimeRange["date_to"]).ToString("yyyy-MM-ddTHH:mm:ssZ")
            }
        }

        $RestSplat = @{
            Method      = 'POST'
            RelativeURI = $RelativeUri
            Body        = @{}
        }

        #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
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
