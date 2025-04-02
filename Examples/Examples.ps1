# Tag hosts imported from a CSV
# Empty Array to add the IDs to
$AxoniusIDs = @()
# Iterate through each item in the CSV
Import-Csv -Path 'C:\temp\TagHosts.csv' | ForEach-Object {
    # Assumes hostname column is named Hostname
    $Hostname = $_.Hostname
    # Query Axonius for the hostname
    $Asset = (Get-AxoniusAssets -AssetType 'devices' -Query "(`"specific_data.data.hostname_preferred`" == `"$($Hostname)`")").assets
    # Check if the asset was found
    if($Asset.internal_axon_id){
        $AxoniusIDs += $Asset.internal_axon_id
    }
    Else{
        # Print to console if asset wasn't found
        Write-Host "No asset found for hostname: $($Hostname)"
    }
}
# Tag the assets
Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag' -InternalAxonIDs $AxoniusIDs