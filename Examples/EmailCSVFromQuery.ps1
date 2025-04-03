$Env:axoniusSettings='{ "BaseURI": ["https://<myaxoniusURL>.on.axonius.com/api/v2/"] }'
Import-Module -Name 'UofIAxonius'
$AxoniusCredential = Import-Clixml -Path '.\Axonius.xml' # See CredentialTips.ps1
$MailCred = Import-Clixml -Path '.\Mail.xml'
New-AxoniusSession -Credential $AxoniusCredential

# Get your query ID from the URL when looking at the query in the web UI
$QueryID = '67ed95bd37a3e1d63dde2d3e'

# Define what fields you want returned about the devices (you get these field names from playing around with Queries in the Axonius UI)
$Fields = @(
    'specific_data.data.hostname_preferred',
    'specific_data.data.network_interfaces.ips_preferred',
    'specific_data.data.software_cves.cve_id_count',
    'specific_data.data.os.os_str_preferred',
    'specific_data.data.last_seen_preferred'
)

# Get the assets returned by the query
$Assets = (Get-AxoniusAssets -AssetType 'devices' -SavedQueryID $QueryID -Fields $Fields).assets

# Format Data for CSV
$CSVData = @()
$Assets | ForEach-Object{
    $CSVData += [pscustomobject]@{
        'IP' = $_.'specific_data.data.network_interfaces.ips_preferred' -join "; "
        'OS' = $_.'specific_data.data.os.os_str_preferred'
        'Hostname' = $_.'specific_data.data.hostname_preferred'
        'VulnCountTotal' = $_.'specific_data.data.software_cves.cve_id_count'
        'LastSeen' = $_.'specific_data.data.last_seen_preferred'
    }
}

# Export the assets to a CSV file
$CSVData | Export-Csv -Path '.\AxoniusAssets.csv' -Force

# Email the CSV file
$EmailSplat = @{
    From = 'no-reply@illinois.edu'
    SmtpServer = 'smtp-cx.socketlabs.com'
    Credential = $MailCred
    Port = '587'
    UseSSL = $true
    To = 'myserviceaccount@illinois.edu'
    Attachments = '.\AxoniusAssets.csv'
    Subject = "Axonius Assets"
}
Send-MailMessage @EmailSplat
