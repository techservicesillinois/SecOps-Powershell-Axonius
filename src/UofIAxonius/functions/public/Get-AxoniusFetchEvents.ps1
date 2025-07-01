<#
.SYNOPSIS
    Get details of fetch events in the system.
.DESCRIPTION
    Retrieves a list of fetch events based on specified filters such as date range, adapter names, or connection IDs. Supports sorting and pagination for managing large result sets.
.PARAMETER DateFrom
    The start of the time range to search from, in "YYYY-MM-DD hh:mm:ss" format. This field is required if using DateTo.
.PARAMETER DateTo
    The end of the time range to search to, in "YYYY-MM-DD hh:mm:ss" format. This field is required if using DateFrom.
.PARAMETER Sort
    A field name to sort the results by. Prefix with "-" for descending and "+" for ascending sort.
    Example: -last_updated
.PARAMETER Page
    A pscustomobject used to divide the result set into discrete subsets of data. The object should include a limit and/or offset property.
    Example: $Page = [pscustomobject]@{'limit'=100; 'offset'=0}
.PARAMETER Adapters
    An array of adapter names to filter the fetch events for specific adapters only.
    Example: @('aws_adapter', 'azure_adapter')
.PARAMETER ConnectionIds
    An array of connection IDs to filter the fetch events for specific connections only.
    Example: @('5fdb23a0af123c0012a3e567', '5fdc9ba3cf6723001956d911')
.EXAMPLE
    Get-AxoniusFetchEvents -DateFrom "2023-10-15 22:00:00" -DateTo "2023-10-17 21:00:00" -Sort "-last_updated"
.EXAMPLE
    Get-AxoniusFetchEvents -DateFrom "2023-10-01 00:00:00" -DateTo "2023-10-02 00:00:00" -Adapters @("aws_adapter") -ConnectionIds @("5fdc9ba3cf6723001956d911")
#>

function Get-AxoniusFetchEvents{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
param (
    [Alias('date_from')]
    [string]$DateFrom,
    [Alias('date_to')]
    [string]$DateTo,
    [string]$Sort,
    [PSCustomObject]$Page,
    [string[]]$Adapters,
    [Alias('connection_ids')]
    [string[]]$ConnectionIds
)
    process{

        If ($DateFrom -and -not $DateTo) {
            Write-Error "If DateFrom is set, DateTo must also be set."
        }
        ElseIf (-not $DateFrom -and $DateTo) {
            Write-Error "If DateTo is set, DateFrom must also be set."
        }

        $RelativeUri = "adapters/fetch_events"

        $RestSplat = @{
            Method      = 'POST'
            RelativeURI = $RelativeUri
            Body        = @{
            }
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
