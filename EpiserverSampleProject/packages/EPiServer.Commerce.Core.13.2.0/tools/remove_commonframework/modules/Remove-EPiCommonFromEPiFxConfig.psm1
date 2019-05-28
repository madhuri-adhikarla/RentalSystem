function Remove-EPiCommonFromEPiFxConfig {

	param ([xml]$epiFxConfig)

	$modified = $false

	$commonVpp = $epiFxConfig.SelectSingleNode("/episerver.framework/virtualPathProviders/add[@name='EPiServerCommon']")
	if ($commonVpp -ne $null) {
		Write-Host "Removing EPiServer Common virtual path provider."
		$commonVpp.ParentNode.RemoveChild($commonVpp) | Out-Null
		$modified = $true
	}

	return $modified
}