Function Get-ConnectionConfigPath($sitePath)
{
	$connectionsStringsPath = join-path $sitePath "connectionStrings.config"
	$webConfigPath = join-path $sitePath "web.config"
	if (Test-Path $connectionsStringsPath) 
	{
		$configPath = $connectionsStringsPath
	}
	elseif (Test-Path $webConfigPath)
	{
		$configPath = $webConfigPath
	}
	else 
	{
		Write-Host "Unable to find a Connection configuration file."
		return
	}
	return $configPath
}