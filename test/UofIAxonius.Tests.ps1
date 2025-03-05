# Need the TDXSettings environment variable set to be able to import the module and run the tests
BeforeAll{
    $env:AxoniusSettings = '{ "BaseURI": [""] }'
    [String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src\UofIAxonius'
    Import-Module -Name $ModuleRoot
}

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\UofIAxonius\UofIAxonius.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}
