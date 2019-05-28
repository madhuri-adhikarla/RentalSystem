param ($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "Get-ProtectedModulesPath.psm1")
Import-Module (Join-Path $toolsPath "Get-WebConfig.psm1")
Import-Module (Join-Path $toolsPath "Remove-Assembly.psm1")
Import-Module (Join-Path $toolsPath "Update-PackagesConfig.psm1")
Import-Module (Join-Path $toolsPath "Remove-AddOnFolder.psm1")
Import-Module (Join-Path $toolsPath "Update-AssemblyBinding.psm1")
Import-Module (Join-Path $toolsPath "Get-ModulesRepositoryPath.psm1")
Import-Module (Join-Path $toolsPath "Remove-RepositoryModule.psm1")

# Get the path to the current project
$projectPath = Split-Path -Parent $project.FullName

# Get the web.config as an XmlDocument
$webConfig = Get-WebConfig $projectPath

# If there is no web.config or there is no episerver element in the config then
# we assume this isn't an EPiServer site project and exit silently
if ($webConfig -eq $null -or $webConfig.configuration.episerver -eq $null)
{
	return
}

# Get the path to the protected modules folder
$protectedModulesPath = Get-ProtectedModulesPath $webConfig $project

Remove-Assembly $webConfig $projectPath "EPiServer.Shell.UI.dll"
Remove-Assembly $webConfig $projectPath "EPiServer.Cms.Shell.UI.dll"
Remove-Assembly $webConfig $projectPath "EPiServer.Cms.Shell.UI.Sources.dll"

Remove-AddOnFolder $protectedModulesPath "Shell"
Remove-AddOnFolder $protectedModulesPath "CMS"
Remove-AddOnFolder $protectedModulesPath "CMS.Sources"
Remove-AddOnFolder $protectedModulesPath "EPiServer.Suite"

# remove modules from repository path 
$repositoryPath = Get-ModulesRepositoryPath $webConfig $project

if($repositoryPath -ne $null)
{ 
 Remove-RepositoryModule $protectedModulesPath $repositoryPath "Shell"
 Remove-RepositoryModule $protectedModulesPath $repositoryPath "CMS"
 Remove-RepositoryModule $protectedModulesPath $repositoryPath "EPiServer.Suite"
 Remove-RepositoryModule $protectedModulesPath $repositoryPath "CMS.Sources"
} 

Update-PackagesConfig $protectedModulesPath "Shell"
Update-PackagesConfig $protectedModulesPath "CMS"
Update-PackagesConfig $protectedModulesPath "CMS.Sources"
Update-PackagesConfig $protectedModulesPath "EPiServer.Suite"

# Writing assembly redirect information 

#load the configuration file for the project
$configPath = Join-Path $projectPath "web.config"
$config = New-Object xml
$config.psbase.PreserveWhitespace = $true
$config.Load($configPath)

$config = Update-AssemblyBinding $config $installPath

# save the new bindingRedirects
$config.Save($configPath)

Remove-Module "Get-WebConfig"
Remove-Module "Get-ProtectedModulesPath"
Remove-Module "Get-ModulesRepositoryPath"
Remove-Module "Update-PackagesConfig"
Remove-Module "Update-AssemblyBinding"
Remove-Module "Remove-Assembly"
Remove-Module "Remove-AddOnFolder"
Remove-Module "Remove-RepositoryModule"
