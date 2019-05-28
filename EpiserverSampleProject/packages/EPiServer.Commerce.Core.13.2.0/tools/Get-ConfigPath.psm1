Function Get-ConfigPath($project)
{
	$projectFile = Get-Item $project.FullName

	#locate the project configuration file
	$webConfigPath = join-path $projectFile.Directory.FullName "web.config"
	$appConfigPath = join-path $projectFile.Directory.FullName "app.config"
	if (Test-Path $webConfigPath) 
	{
		$configPath = $webConfigPath
	}
	elseif (Test-Path $appConfigPath)
	{
		$configPath = $appConfigPath
	}
	else 
	{
		Return
	}
	$configPath
}

Export-ModuleMember -function Get-ConfigPath