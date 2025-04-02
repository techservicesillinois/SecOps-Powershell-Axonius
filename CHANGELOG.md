# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
### Changed
### Removed

## [1.0.1] - 2025-04-01

### Changed

- Query params are case-sensitive, discovered query params were not working properly in Get-AxoniusQueries and Get-AxoniusAssetsByID. Added ToLower() functions for these params.


## [1.0.0] - 2025-03-24

### Added

- Get-AxoniusAssetCount
- Set-AxoniusCustomField
- Get-AxoniusAssetInvestigationFields
- Get-AxoniusQueryFolders
- Get-AxoniusQueryByID
- Remove-AxoniusQueryByIDs

### Changed

- Fix example in Remove-AxoniusTags
- Batchsize parameter added to Remove and Add Tag functions
- README now includes To Do list

## [0.0.2] - 2025-03-11

### Added

- New-AxoniusSession
- Invoke-AxoniusRestCall
- Add-AxoniusAssetLink
- Add-AxoniusTags
- Get-AxoniusAssetByID
- Get-AxoniusAssetCount
- Get-AxoniusAssetFields
- Get-AxoniusAssets
- Get-AxoniusQueries
- Remove-AxoniusAssetLink
- Remove-AxoiusTag
- CONTRIBUTING.md
- icon.png

### Changed

- Supported version and reporting vulnerabilities language in SECURITY.md
- Standard module settings and link to icon in UofIAxonius.psd1
- Base URI example needed a /v2/ in UofIAxonius.psm1
- Reference to TDX replaced with Axonius in Tests


## [0.0.1] - 2025-03-05

### Added

- Module scaffolding. repo initialization
