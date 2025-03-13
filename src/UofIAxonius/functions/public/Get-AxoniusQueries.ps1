<#
.Synopsis
    Get details of all saved queries.
.DESCRIPTION
    Get details of all saved queries.
.PARAMETER FolderID
    The ID of the folder to pull from. Use all to pull from all folders.
    Defaults to 'all'.
.PARAMETER UsedIn
    A list of system modules where the queries are used
.PARAMETER IncludeMetadata
    When true, returns metadata such as item count and paging information (page number, offset, limit). For use when returning large amounts of data
    Defaults to 'true'.
.PARAMETER Offset
    The number of rows to skip from the beginning of the result set
.PARAMETER Limit
    The number of rows to return from the result set
    Defaults to 1000.
.EXAMPLE
    Get-AxoniusQueries
.EXAMPLE
    Get-AxoniusQueries -FolderID 'Public' -UsedIn @('dashboard','enforcements') -IncludeMetadata -Offset 100 -Limit 100
#>
function Get-AxoniusQueries{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Alias('folder_id')]
        [string]$FolderID = 'all',
        [Alias('used_in')]
        [string[]]$UsedIn,
        [Alias('include_metadata')]
        [switch]$IncludeMetadata,
        [int]$Offset,
        [int]$Limit
    )

    process{

        $QueryObjects = @()

        # Always add folder_id, even if it's the default or explicitly set
        $QueryObjects += "folder_id=$FolderID"

        If(-not $IncludeMetadata){
            $QueryObjects += "&include_metadata=false"
        }

        $PSCmdlet.MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object {
            $alias = $MyInvocation.MyCommand.Parameters[$_.Key].Aliases[0]
            $paramName = $alias ?? $_.Key

            # Handle array parameters by adding multiple entries
            if ($_.Value -is [array]) {
                foreach ($value in $_.Value) {
                    $QueryObjects += "$($paramName)=$value"
                }
            }
            else {
                $QueryObjects += "$($paramName)=$($_.Value)"
            }
        }

        $QueryString = $QueryObjects -join "&"
        $RelativeUri = "queries?$($QueryString)"

        $RestSplat = @{
            Method      = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-AxoniusRestCall @RestSplat
        $Response
    }
}
