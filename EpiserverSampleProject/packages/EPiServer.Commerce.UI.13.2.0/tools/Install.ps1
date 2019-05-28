param ($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "Get-WebConfig.psm1")
Import-Module (Join-Path $toolsPath "Get-ProtectedModulesPath.psm1")
Import-Module (Join-Path $toolsPath "Remove-Assembly.psm1")
Import-Module (Join-Path $toolsPath "Remove-AddOnFolder.psm1")
Import-Module (Join-Path $toolsPath "Update-PackagesConfig.psm1")
Import-Module (Join-Path $toolsPath "Get-ConfigPath.psm1")
Import-Module (Join-Path $toolsPath "Get-Config.psm1")
Import-Module (Join-Path $toolsPath "Update-AssemblyBinding.psm1")

$fxPackage = Get-package | where-object { $_.id -eq "EPiServer.Framework"} | Sort-Object -Property Version -Descending | select-object -first 1
$fxTools =[System.IO.Path]::Combine( $installPath,  ".." , $fxPackage.Id + "." + $fxPackage.Version , "tools")
$cmsConfigUpdatePath =[System.IO.Path]::Combine($installPath, "tools\webconfig-update.config")
$sitePath = (Get-ChildItem $project.Fullname).Directory.FullName

# Get the path to the current project
$projectPath = Split-Path -Parent $project.FullName

# Get the web.config as an XmlDocument (this imports exported sections into the
# same document so it can not be saved in this state)
$webConfig = Get-WebConfig $projectPath
$epideployPath = Join-Path $fxTools 'epideploy.exe'

# If there is no web.config or there is no episerver element in the config then
# we assume this isn't an EPiServer site project and exit silently
if ($webConfig -eq $null -or $webConfig.configuration.episerver -eq $null)
{
	return
}
else 
{
	Write-Host "Adding Framework configuration updates"
	& $epideployPath -s $sitePath -a config -p $cmsConfigUpdatePath
}

# Get the path to the protected modules folder
$protectedModulesPath = Get-ProtectedModulesPath $webConfig $project

Remove-Assembly $webConfig $projectPath "EPiServer.Commerce.AddOns.UI.dll"

Remove-AddOnFolder $protectedModulesPath "EPiServer.Commerce.AddOns.UI"

Update-PackagesConfig $protectedModulesPath "EPiServer.Commerce.AddOns.UI"

#add/update binding redirects for assemblies in the current package
$configPath = Get-ConfigPath $project
if ($configPath -eq $null)
{
	Write-Host "Unable to find a configuration file, binding redirect not configured."
}
else
{
	$config = Get-Config $configPath
	Update-AssemblyBinding $config $installPath | Out-Null
	$config.Save($configPath)
}