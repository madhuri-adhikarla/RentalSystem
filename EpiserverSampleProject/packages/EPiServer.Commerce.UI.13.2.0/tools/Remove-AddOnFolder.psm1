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
        # Remove the add-on folder and all children.
		Write-Host "Removing folder - $addOnFolderPath"
        Remove-Item $addOnFolderPath -Force -Recurse -ErrorAction Stop
    }
    catch [Exception]
    {
        # Show a message box explaining that the package.config couldn't be saved
		$errorMsg = "The package installer was unable to delete the folder ""$addOnFolderPath"". Please delete this folder and its contents manually."
		Write-Host $errorMsg
        [System.Windows.Forms.MessageBox]::Show($errorMsg, "Error Deleting Add-On Folder") | Out-Null
    }
}

Export-ModuleMember -Function Remove-AddOnFolder