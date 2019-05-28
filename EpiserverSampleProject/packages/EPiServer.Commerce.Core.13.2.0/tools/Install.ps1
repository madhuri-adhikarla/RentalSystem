param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath "Get-ConfigPath.psm1")
Import-Module (Join-Path $toolsPath "Remove-AutoInstallModuleRegistration.psm1")
Import-Module (Join-Path $toolsPath "Remove-MarketingConfiguration.psm1")
Import-Module (Join-Path $toolsPath "Remove-CustomIEHeader.psm1")
Import-Module (Join-Path $toolsPath "Get-Config.psm1")
Import-Module (Join-Path $toolsPath "Update-AssemblyBinding.psm1")
Import-Module (join-path $toolsPath "Get-PackagesToolPath.psm1")

Function RemoveObsoleteConfigureFiles([String] $sitePath)
{
	#Remove obsolete files relate to Mediachase.Cms			
	$mediachaseCmsConfigPath = Join-Path $sitePath "Configs\ecf.cms.config";
	if(Test-Path($mediachaseCmsConfigPath)) {
		Write-Host "Removing file $mediachaseCmsConfigPath"
		Remove-Item $mediachaseCmsConfigPath
	}
}

Function RemoveObsoleteAssembly([String] $sitePath, [String] $assemblyFile)
{
    $assemblyPath = [io.path]::combine($sitePath, "bin", $assemblyFile)
    if(Test-Path($assemblyPath)) {
        Write-Host "Removing file $assemblyPath"
        Remove-Item $assemblyPath
    }
}


#Get the Framework package
$thePackage = Get-package -ProjectName $project.ProjectName | where-object { $_.id -eq "EPiServer.Framework"} | Sort-Object -Property Version -Descending | select-object -first 1
#Get EPiDeploy.exe Path
$frameWorkToolPath = Get-PackagesToolPath $installPath "EPiServer.Framework" $thePackage.Version
$deployEXEPath =  join-Path ($frameWorkToolPath) "epideploy.exe"
$commerceConfigBaselinePath =[System.IO.Path]::Combine($installPath, "tools\webconfig-baseline.config")
$projectFilePath = Get-ChildItem $project.Fullname
$sitePath = $projectFilePath.Directory.FullName

#Remove AutoInstallMetaDataModule registrations
$bafDataConfigPath = Join-Path $sitePath "Configs\baf.data.manager.config"
if (Test-Path $bafDataConfigPath)
{
    $bafConfig = Get-Config $bafDataConfigPath
    Remove-AutoInstallModuleRegistration $bafConfig
    $bafConfig.Save($bafDataConfigPath)
}

$bafConfigPath = Join-Path $sitePath "Configs\baf.config"
if (Test-Path $bafConfigPath)
{
    $bafConfig = Get-Config $bafConfigPath
    Remove-MarketingConfiguration $bafConfig
    $bafConfig.Save($bafConfigPath)
}

#add/update binding redirects for assemblies in the current package
$configPath = Get-ConfigPath $project
if ($configPath -eq $null)
{
    Write-Host "Unable to find a configuration file, binding redirect not configured."
}
else
{
    $config = Get-Config $configPath
    Remove-CustomIEHeader $config | Out-Null
    Update-AssemblyBinding $config $installPath | Out-Null
    $config.Save($configPath)
	
    ## Install baseline if not already added
    if(-not (Test-Path (Join-Path $sitePath "web.config")))
    {
        Write-Host "Unable to find web.config file, Commerce baseline configuration not added."
    }
    elseif ($config.configuration.CommerceFramework -eq $null)
    {
        Write-Host "Adding Commerce baseline configuration"
        & $deployEXEPath -s $sitePath -a config -p $commerceConfigBaselinePath
    }
}

RemoveObsoleteConfigureFiles $sitePath

RemoveObsoleteAssembly $sitePath "Mediachase.Library.AmazonProviders.dll"

RemoveObsoleteAssembly $sitePath "Mediachase.Commerce.Marketing.Validators.dll"



