<#
.SYNOPSIS
Removes EPiServer CommonFramework related configuration.

.DESCRIPTION
Removes EPiServer CommonFramework related configuration from web.config, EPiServerFramework.config
and connectionStrings.config.

Note: This scripts supports only the scenario where the episerver.framework and connectionStrings
sections are in separate files and all other Common Framework related config (e.g. the sections
episerver.common, nhibernate, hibernate-configuration and episerver.shell) is in web.config.

.PARAMETER sitePath
Path to the root folder of the site (containing web.config, EPiServerFramework.config and
connectionStrings.config).

#>

param ([string] $sitePath)

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Path

Import-Module $scriptPath\Modules\Remove-EPiCommonFromWebConfig.psm1
Import-Module $scriptPath\Modules\Remove-EPiCommonFromEPiFxConfig.psm1
Import-Module $scriptPath\Modules\Remove-EPiCommonFromConnectionStringsConfig.psm1

if ($sitePath) {
	$sitePath = Resolve-Path $sitePath
}
else {
	throw "You have to specify the path to the site root."
}

$webConfigPath = Join-Path $sitePath web.config
if (Test-Path $webConfigPath) {
	$webConfigFile = Get-Item $webConfigPath

	[xml]$webConfig = Get-Content $webConfigFile
	if (Remove-EPiCommonFromWebConfig $webConfig) {
		Write-Host "Saving changes to $webConfigFile"
		$webConfig.Save($webConfigFile.FullName)
	} else {
		Write-Host "No changes required in $webConfigFile"
	}
} else {
	Write-Warning "No web.config file found in $sitePath"
}

$epiFxConfigPath = Join-Path $sitePath episerverFramework.config
if (Test-Path $epiFxConfigPath) {
	$epiFxConfigFile = Get-Item $epiFxConfigPath

	[xml]$epiFxConfig = Get-Content $epiFxConfigFile

	if (Remove-EPiCommonFromEPiFxConfig $epiFxConfig) {
		Write-Host "Saving changes to $epiFxConfigFile"
		$epiFxConfig.Save($epiFxConfigFile.FullName)
	} else {
		Write-Host "No changes required in $epiFxConfigFile"
	}
} else {
	Write-Warning "No EPiServerFramework.config found in $sitePath"
}

$connectionStringsConfigPath = Join-Path $sitePath connectionStrings.config
if (Test-Path $connectionStringsConfigPath) {
	$connectionStringsConfigFile = Get-Item $connectionStringsConfigPath

	[xml]$connectionStringsConfig = Get-Content $connectionStringsConfigFile

	if (Remove-EPiCommonFromConnectionStringsConfig $connectionStringsConfig) {
		Write-Host "Saving changes to $connectionStringsConfigFile"
		$connectionStringsConfig.Save($connectionStringsConfigFile.FullName)
	} else {
		Write-Host "No changes required in $connectionStringsConfigFile"
	}
} else {
	Write-Warning "No connectionStrings.config file found in $sitePath"
}
