Function Copy-DB($toolsPath, $sitePath, $dbName, $emptyMdfFile)
{
	$appData = join-path $sitePath  "App_Data"
	$appData = join-Path $appData $dbName
	if ([System.IO.File]::Exists([System.IO.Path]::Combine($sitePath, $appData)) -eq $false)
	{
		Create-Folder $sitePath "App_Data"
		[void][System.IO.File]::Copy($emptyMdfFile, $appData)
	}
}

Function Create-Folder($sitePath, $foldername)
{
	if ([System.IO.File]::Exists([System.IO.Path]::Combine($sitePath, $foldername)) -eq $false)
	{
		[void][System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($sitePath, $foldername))
	}
}

Export-ModuleMember -Function Copy-DB