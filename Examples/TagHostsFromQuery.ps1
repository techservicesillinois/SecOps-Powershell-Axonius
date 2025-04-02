$Env:axoniusSettings='{ "BaseURI": ["https://university-of-illinois-df61e3eeae2c28c1.on.axonius.com/api/v2/"] }'
Import-Module -Name 'UofIAxonius'
$AxoniusCredential = Import-Clixml -Path '.\Axonius.xml' # See CredentialTips.ps1
New-AxoniusSession -Credential $AxoniusCredential

# Get your query ID from the Axnonius URL when looking at the query on the web UI
$QueryID = '67ed95bd37a3e1d63dde2d3e'
# Get the assets returned by the query
$Assets = (Get-AxoniusAssets -AssetType 'devices' -SavedQueryID $QueryID).assets
# Tag the assets
Add-AxoniusTags -AssetType 'devices' -Tags 'Test Tag' -InternalAxonIDs $Assets.internal_axon_id
