# The API Key is always the username, and the API Secret is always the password

# Attended Automation - If a person is manually running the script you can keep it simple and just prompt for credentials
$AxoniusCredential = Get-Credential

# If you are running this from Azure Automation, you can use their Credential store like so
$AxoniusCredential = Get-AutomationPSCredential -Name 'AxoniusCredential'

# If you are running this in a tradtional unattended way such as a scheduled task, export encrypted credentials to an XML file one time, and retrieve them like so
# One time export
$Credential = Get-Credential
$Credential | Export-Clixml -Path '.\Axonius.xml'
# Retrieve the credential in your script
$AxoniusCredential = Import-Clixml -Path '.\Axonius.xml'
