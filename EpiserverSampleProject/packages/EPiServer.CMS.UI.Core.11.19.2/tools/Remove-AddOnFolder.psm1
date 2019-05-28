function Remove-AddOnFolder
{
    param ($protectedModulesPath, $packageName)

    # Validate that the package name parameter exists
    if ($packageName -eq $null -or $packageName -eq "")
    {
        throw (New-Object ArgumentException("The package name was not specified."))
    }  
	
	# Construct the path to the protected module folder
    $addOnFolderPath = Join-Path $protectedModulesPath $packageName

    # If the add-on folder doesn't exist then don't need to delete anything and we exit silently
    if (!(Test-Path $addOnFolderPath))
    {
        return
    }    

    try
    {
        # Remove the add-on folder and all children only if it exists inside packages.config/disablePackagesConfig  
		$packagesConfigPath = Join-Path $protectedModulesPath "packages.config"
        $disablePackagesConfigPath = Join-Path $protectedModulesPath "packagesDisabled.config"

         if ((IsPackageFoundInConfig $packagesConfigPath $packageName) -or (IsPackageFoundInConfig $disablePackagesConfigPath $packageName)) 
         {
             Write-Host "Removing folder - $addOnFolderPath"
             Remove-Item $addOnFolderPath -Force -Recurse -ErrorAction Stop  
         }
    }
    catch [Exception]
    {
        # Show a message box explaining that the package.config couldn't be saved
		$errorMsg = "The package installer was unable to delete the folder ""$addOnFolderPath"". Please delete this folder and its contents manually."
		Write-Host $errorMsg
        [System.Windows.Forms.MessageBox]::Show($errorMsg, "Error Deleting Add-On Folder") | Out-Null
    }
}

# returns true if packageName has entry in config file found at given $configPath location
function IsPackageFoundInConfig ($configPath, $packageName)
{
    
    if(($configPath -ne $null -or $configPath -ne "") -and (Test-Path $configPath)) 
    {
         # Load the packages.config as an XmlDocument
        [xml] $packagesConfig = Get-Content $configPath

        # Get the package entry for the packageName
        $packageElement = $packagesConfig.SelectSingleNode("/packages/package[@id=""$packageName""]")
        return ($packageElement -ne $null -and $packageElement -ne "") 
    }

    return $False
}

Export-ModuleMember -Function Remove-AddOnFolder