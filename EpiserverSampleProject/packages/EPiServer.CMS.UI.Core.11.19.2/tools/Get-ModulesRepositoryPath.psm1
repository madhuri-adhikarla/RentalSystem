function Get-ModulesRepositoryPath
{
    param ($webConfig, $project)

    # Get the packaging element
    $packagingElement = $webConfig.configuration."episerver.packaging"

    # If the packaging element exists then read the protected modules path from the attribute
    if ($packagingElement -ne $null)
    {
        $repositoryPath = $packagingElement.GetAttribute("repositoryPath")
    }

    # If the repository path is null or empty then it isn't defined on the packing element and
    # we should fallback to the default path ([appDataPath]\ModulesRepository).
    if ($repositoryPath -eq $null -or $repositoryPath -eq "")
    {
        # Get the app data element
        $appDataElement = $webConfig.configuration."episerver.framework".appData

        # Read the basePath attribute and append the Modules folder to the path
        if ($appDataElement -ne $null -and $appDataElement.HasAttribute("basePath"))
        {
            $repositoryPath = (Join-Path $appDataElement.GetAttribute("basePath") "ModulesRepository")
        }
    }

    # Resolve an absolut path for the modules
    $projectFilePath = Get-ChildItem $project.Fullname
    $sitePath = $projectFilePath.Directory.FullName

    if(![System.IO.Path]::IsPathRooted($repositoryPath))
    {
        # If it is a relative path join it with the $sitePath to create an absolut path
        $repositoryPath = Join-Path $sitePath $repositoryPath
    }

    return $repositoryPath
}

Export-ModuleMember -Function Get-ModulesRepositoryPath