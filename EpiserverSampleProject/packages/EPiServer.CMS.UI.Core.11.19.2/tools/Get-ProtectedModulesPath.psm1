function Get-ProtectedModulesPath
{
	param ($webConfig, $project)

	# Get the packaging element
    $packagingElement = $webConfig.configuration."episerver.packaging"

    # If the packaging element exists then read the protected modules path from the attribute
    if ($packagingElement -ne $null)
    {
        $protectedModulesPath = $packagingElement.GetAttribute("protectedPath")
    }

    # If the protected modules path is null or empty then it isn't defined on the packing element and
    # we should fallback to the default path ([appDataPath]\Modules).
    if ($protectedModulesPath -eq $null -or $protectedModulesPath -eq "")
    {
        # Get the app data element
        $appDataElement = $webConfig.configuration."episerver.framework".appData

        # Read the basePath attribute and append the Modules folder to the path
        if ($appDataElement -ne $null -and $appDataElement.HasAttribute("basePath"))
        {
            $protectedModulesPath = (Join-Path $appDataElement.GetAttribute("basePath") "Modules")
        }
    }

	# Resolve an absolut path for the modules
	$projectFilePath = Get-ChildItem $project.Fullname
	$sitePath = $projectFilePath.Directory.FullName

	if(![System.IO.Path]::IsPathRooted($protectedModulesPath))
	{
		# If it is a relative path join it with the $sitePath to create an absolut path
		$protectedModulesPath = Join-Path $sitePath $protectedModulesPath
	}

    return $protectedModulesPath
}

Export-ModuleMember -Function Get-ProtectedModulesPath