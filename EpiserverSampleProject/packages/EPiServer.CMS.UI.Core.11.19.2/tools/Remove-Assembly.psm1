function Remove-Assembly
{
    param ($webConfig, $projectPath, $assemblyName)

    # Validate that the assembly name parameter exists
    if ($assemblyName -eq $null -or $assemblyName -eq "")
    {
        throw (New-Object ArgumentException("The assembly name was not specified."))
    }

    # Get the probing element from the web.config
    $probingElement = $webConfig.configuration.runtime.assemblyBinding.probing

    # If the probing element doesn't exist then do an early exit
    if ($probingElement -eq $null)
    {
        return
    }

    # Get the probing paths as an array an iterate over them
    $probingElement.GetAttribute("privatePath").Split(";") | ForEach-Object {
        # Construct path to the assembly based on the probing path
        $probingPath = Join-Path $projectPath (Join-Path $_ $assemblyName)
        if (Test-Path $probingPath)
        {
            try
            {
                # Remove the redundant assemblies from this path
				Write-Host "Removing assembly - $probingPath"
                Remove-Item $probingPath -Force -ErrorAction Stop
            }
            catch [Exception]
            {

                # Show a message box explaining that the assembly couldn't be deleted
				$errorMsg = "The package installer was unable to delete the file ""$probingPath"". Please delete this file manually."
				Write-Host $errorMsg
                [System.Windows.Forms.MessageBox]::Show($errorMsg, "Error Deleting File") | Out-Null
            }
        }
    }
}

Export-ModuleMember -Function Remove-Assembly