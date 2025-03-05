<#
.Synopsis
    This function creates an Axonius user session to be used with the other functions in this module.
.DESCRIPTION
    This function creates an Axonius user session to be used with the other functions in this module.
.PARAMETER Credential
    Credential object with your Axonius API Key and Secret.
.EXAMPLE
    $Credential = Get-Credential
    PowerShell credential request
    Enter your credentials.
    User: <APIKEY>
    Password for user <APIKEY>: <APISECRET>
    New-AxoniusSession -Credential $Credential
.EXAMPLE
    You can also export/import credentials to an XML file to use these functions without entering your API key each session (less secure):
    $Credential = Get-Credential (only needs to be done once)
    $Credential | Export-Clixml -Path '.\AxoniusAPIKey.xml' (only needs to be done once)
    $Credential = Import-Clixml -Path '.\AxoniusAPIKey.xml'
    New-AxoniusSession -Credential $Credential
#>
function New-AxoniusSession{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
    )

    process{
        if ($PSCmdlet.ShouldProcess("$($Credential)")){
            # Extract the API key (password) from the PSCredential object
            $Script:Session = $Credential
        }
    }
}
