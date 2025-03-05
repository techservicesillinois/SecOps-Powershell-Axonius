# Use environment variable for AxoniusSettings (explained in README.md)
if ($env:AxoniusSettings) {
    $script:Settings=$env:AxoniusSettings | ConvertFrom-Json
}
else {
    Write-Error -Message "No environment variable AxoniusSettings found.
    Set `$ENV:AxoniusSettings to a JSON-formatted string containing a BaseURI property, for example:
    `$ENV:AxoniusSettings='{ ""BaseURI"": [""https://{axonius-URI}:{port}/api/v2/""] }'"
}

$Script:Session = $NULL
[int]$Script:APICallCount = 0

[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}
