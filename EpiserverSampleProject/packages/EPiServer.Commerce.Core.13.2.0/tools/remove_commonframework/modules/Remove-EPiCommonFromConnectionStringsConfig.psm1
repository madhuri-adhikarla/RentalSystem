function Remove-EPiCommonFromConnectionStringsConfig {

	param ([xml]$connectionStringsConfig)

	$modified = $false

	$commonConnectionString = $connectionStringsConfig.SelectSingleNode("/connectionStrings/add[@name='EPiServerCommon']")
	if ($commonConnectionString -ne $null) {
		Write-Host "Removing EPiServer Common connection string."
		$commonConnectionString.ParentNode.RemoveChild($commonConnectionString) | Out-Null
		$modified = $true
	}

	return $modified
}