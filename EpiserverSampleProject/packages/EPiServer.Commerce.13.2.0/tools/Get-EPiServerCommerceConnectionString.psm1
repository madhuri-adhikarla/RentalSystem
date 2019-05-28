Function Get-EPiServerCommerceConnectionString($WebConfigFile)
{
	if (Test-Path $WebConfigFile) 
	{
		$webConfig = [XML] (Get-Content $WebConfigFile)
		if ($webConfig.configuration.connectionStrings.add -ne $null)
		{
			return FindEpiServerCommerceConnection($webConfig.configuration.connectionStrings.add)
		}
		if ($webConfig.connectionStrings.add -ne  $null) 
		{
			return FindEpiServerCommerceConnection($webConfig.connectionStrings.add)
		}
		$configSourcePath = Join-Path ([System.IO.Path]::GetDirectoryName($WebConfigFile)) $webConfig.configuration.connectionStrings.configSource
		if (($webConfig.configuration.connectionStrings.configSource -ne $null) -and (Test-Path $configSourcePath)) 
		{
			return Get-EPiServerCommerceConnectionString(Join-path  ([System.IO.Path]::GetDirectoryName($WebConfigFile))  $webConfig.configuration.connectionStrings.configSource)
		}
	}
	return $null
}

Function FindEpiServerCommerceConnection($addElements)
{
	foreach($connString in $addElements)
	{
		if ($connString.name -eq 'EcfSqlConnection')
		{
			return $connString.connectionString
		}
	}
	return $null
}

Export-ModuleMember -Function Get-EPiServerCommerceConnectionString