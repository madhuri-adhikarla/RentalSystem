Function Copy-EcfConfigsIfNotExist($project, $toolsPath, $sitePath)
{
	$configsResourcePath = Join-Path $toolsPath ".\Configs"
	$configsPath = Join-Path $sitePath "\Configs"
	if (-Not (Test-Path $configsPath))
	{
		Copy-Item $configsResourcePath $sitePath -Recurse
		Add-ProjectItems $project $configsPath
	}
}

# due to the problem in VS 2015 + NuGet 3.x, where $project.ProjectItems.AddFromDirectory
# does not add files to the project, we need to use AddFromFile instead.
Function Add-ProjectItems($project, $directory)
{
	# gets all files under $directory and add them to $project.
	# note that this does not add files under sub directories.
	$files = Get-ChildItem $directory
	ForEach ($file in $files) {
		$project.ProjectItems.AddFromFile($file.fullName)
	}
}

Export-ModuleMember -Function Add-ProjectItems
Export-ModuleMember -Function Copy-EcfConfigsIfNotExist
