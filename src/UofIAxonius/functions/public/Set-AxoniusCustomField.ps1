<#
.SYNOPSIS
    Update the custom fields of assets.
.DESCRIPTION
    Update the custom fields of assets.
.PARAMETER AssetType
    Retrieve assets for the selected asset type.
.PARAMETER CustomFieldName
    The name of the custom field as it appears in 'Custom Data Management'.
.PARAMETER CustomFieldValues
    The value(s) to be used for updating the custom field. For Single value fields, provide a list with a single value.
.PARAMETER InternalAxonIDs
    A list of Internal IDs of the assets that tags will be applied to
.EXAMPLE
    Set-AxoniusCustomField -AssetType 'devices' -CustomFieldName 'CDB Contact' -CustomFieldValue "test@illinois.edu" -InternalAxonIDs '7bbdcc3098cef05549d90e3178df241d','6e966157b2eb7308cc3dc0b9b6b787de'
#>
function Set-AxoniusCustomField{
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AssetType,
        [Parameter(Mandatory = $true)]
        [string]$CustomFieldName,
        [Parameter(Mandatory = $true)]
        [string[]]$CustomFieldValues,
        [Parameter(Mandatory = $true)]
        [string[]]$InternalAxonIDs
    )

    process{
        #adapters_data.gui.custom_cdb_contact
        if ($PSCmdlet.ShouldProcess("[$($CustomFieldName)] for [$($InternalAxonIDs.count)] assets", "Update Custom Field")) {

            # Replace dots with _DOT__DOT_, dashes and spaces with underscores, remove other special characters, and lowercase the string
            $CustomFieldName = ($CustomFieldName -replace '\.', '_DOT__DOT_' -replace '[- ]', '_' -replace '[^\w]', '').ToLower()
            $CustomFieldName = $CustomFieldName -replace 'dot', 'DOT'
            $CustomFieldName = "adapters_data.gui.custom_$($CustomFieldName)"

            $RelativeUri = "assets/$($AssetType)/update_custom_fields"

            $RestSplat = @{
                Method      = 'PATCH'
                RelativeURI = $RelativeUri
                Body        = @{
                    'internal_axon_ids' = $InternalAxonIDs
                    'custom_field' = @{
                        'field_name' = $CustomFieldName
                        'value' = $CustomFieldValues
                    }
                }
            }

            $Response = Invoke-AxoniusRestCall @RestSplat
            $Response
        }
    }
}
