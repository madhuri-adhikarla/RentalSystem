function Update-PackagesConfig
{
    param ($protectedModulesPath, $packageName)

    # Validate that the package name parameter exists
    if ($packageName -eq $null -or $packageName -eq "")
    {
        throw (New-Object ArgumentException("The package name was not specified."))
    }

    Function Update($packagesConfigPath)
    {
        # If the packages.config file doesn't exist then something is wrong with site configuration and we exit silently
        if (!(Test-Path $packagesConfigPath))
        {
            return
        }

        # Load the packages.config as an XmlDocument
        [xml] $packagesConfig = Get-Content $packagesConfigPath

        # Get the package entry for the redundant add-on
        $packageElement = $packagesConfig.SelectSingleNode("/packages/package[@id=""$packageName""]")
        if ($packageElement -eq $null)
        {
            return
        }

        # Remove the package entry for the redundant add-on and pipe to nothing so that we don't spam the console
        $packageElement.ParentNode.RemoveChild($packageElement) | Out-Null

        try
        {
            # Save the updated config file
            Set-Content $packagesConfigPath -Value $packagesConfig.OuterXml -Force -ErrorAction Stop
        }
        catch [Exception]
        {
            # Show a message box explaining that the package.config couldn't be saved
            [System.Windows.Forms.MessageBox]::Show("The package installer was unable to update the file ""$packagesConfigPath"". Please update this file manually.", "Error Updating Packages Configuration") | Out-Null
        }
    }

    # Update the packages.config
    Update(Join-Path $protectedModulesPath "packages.config")

    #Update the disabledPackages.config
    Update(Join-Path $protectedModulesPath "packagesDisabled.config")
}

Export-ModuleMember -Function Update-PackagesConfig