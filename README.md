![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-Axonius/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-Axonius/workflows/ScriptAnalyzer/badge.svg)

# What is This?

This Powershell module acts as a wrapper for the Axonius REST API, allowing you to create scripts that run operations tasks in Axonius

# How do I install it?

The latest stable release is always available via the [PSGallery](https://www.powershellgallery.com/packages/UofIAxonius).
```powershell
# This will install on the local machine
Install-Module -Name 'UofIAxonius'
```

# How does it work?

After installing the module, import the module using:
```Powershell
Import-Module -Name 'UofIAxonius'
```
For a list of functions:
```Powershell
Get-Command -Module 'UofIAxonius'
```
Get-Help is available for all functions in this module. For example:
```Powershell
Get-Help 'Get-AxoniusQueries' -Full
```


# How do I help?

Submit a pull request on GitHub.

# End-of-Life and End-of-Support Dates

As of the last update to this README, the expected End-of-Life and End-of-Support dates of this product are November 2026.

End-of-Life was decided upon based on these dependencies and their End-of-Life dates:

- Powershell 7.4 (November 2026)

# To Do

- Adapters
- Dashboards
- Data Scopes
- Discovery
- Encryption
- Enforcements
- Enrichments
- Gateways
- Roles
- Tags
- Users
- Assets
  - Get-AxoniusAssetInvestigation
- Queries
  - Set-AxoniusQuery
  - New-AxoniusQuery