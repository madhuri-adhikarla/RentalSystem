param($installPath, $toolsPath, $package, $project)

#Import Modules
Import-Module (Join-Path $toolsPath "Copy-DB.psm1")
Import-Module (Join-Path $toolsPath "Copy-EcfConfigsIfNotExist.psm1")
Import-Module (Join-Path $toolsPath "Get-Config.psm1")
Import-Module (Join-Path $toolsPath "Get-ConfigPath.psm1")
Import-Module (Join-Path $toolsPath "Get-ConnectionConfigPath.psm1")
Import-Module (Join-Path $toolsPath "Get-EPiServerCommerceConnectionString.psm1")
Import-Module (Join-Path $toolsPath "Get-PackagesToolPath.psm1")
Import-Module (Join-Path $toolsPath "Set-CommerceManagerSearchIndexBasePath.psm1")
Import-Module (Join-Path $toolsPath "Set-NameSpace.psm1")

Function Get-InstalledPackage
{
	param ([string]$projectName, [string]$packageId)

	return Get-Package -ProjectName $projectName | Where-Object { $_.id -eq $packageId} | Sort-Object -Property Version -Descending | Select-Object -First 1
}

$projectFilePath = Get-ChildItem $project.Fullname

$sitePath = $projectFilePath.Directory.FullName

$WebConfigFile = Get-ConfigPath $project

$epiConnection = Get-EPiServerCommerceConnectionString($WebConfigFile)
if ($epiConnection -eq $null)
{
	Write-Host "Starting Deploy into $($project.ProjectName)"

	#Get the Framework package
	$frameworkPackage = Get-InstalledPackage $project.ProjectName "EPiServer.Framework"

	# Get EPiDeploy.exe Path
	$frameworkToolPath = Get-PackagesToolPath $installPath "EPiServer.Framework" $frameworkPackage.Version
	$deployEXEPath = Join-Path ($frameworkToolPath) "epideploy.exe"

	$episerverWebConfig = Join-Path $toolsPath "EPiServer.Commerce.config"
	# Deploy Web Config
	&$deployEXEPath  -a config -s $sitePath  -p $episerverWebConfig

	# Make unique DB name
	$seed = [GUID]::NewGuid()
	$uniqueDB = "EcfSqlConnection_" + $seed.ToString("N").Substring(0,8)

	# Copying DB -> App_Data
	Write-Host "Copying $($uniqueDB) To $($project.ProjectName) -> App_Data"
	$emptyMdfFile = Join-Path $toolsPath "EPiServer.Commerce.mdf"

	Copy-DB $toolsPath $sitePath "$($uniqueDB).mdf" $emptyMdfFile

	$connectionPath = Get-ConnectionConfigPath $sitePath
	$connectionContent = Get-Content -Path $connectionPath

    # Modify ConnectionString if version only supports LocalDB\v11.0
    $vsVersion = [System.Version]::Parse($project.DTE.Version)
    $localDBDataSource = if ($vsVersion.Major -lt 14) { "(LocalDb)\v11.0" } else { "(LocalDb)\MSSQLLocalDB" }
    $connectionContent = $connectionContent -replace "{LocalDB_DataSource}", $localDBDataSource

	# Modify ConnectionString according to seed
	$connectionContent = $connectionContent -replace "{EcfSqlConnection_SEED}", $uniqueDB

	Set-Content $connectionContent -path $connectionPath

	$commerceCorePackage = $frameworkPackage = Get-InstalledPackage $project.ProjectName "EPiServer.Commerce.Core"
	$commerceCoreToolsPath = Get-PackagesToolPath $installPath "EPiServer.Commerce.Core" $commerceCorePackage.Version
	$commerceCoreDbPath = Join-Path ($commerceCoreToolsPath) "EPiServer.Commerce.Core.sql"

	#Update search config
	$searchConfigPath = Join-Path $toolsPath "Configs\Mediachase.Search.Config"
	$searchIndexBasePath = "[appDataPath]\Search\ECApplication\"
	$searchConfig = Get-Config $searchConfigPath
	Set-CommerceManagerSearchIndexBasePath $searchConfig $searchIndexBasePath
	$searchConfig.Save($searchConfigPath)

    #Copy ecf Configs to the site if not exist
	Copy-EcfConfigsIfNotExist $project $toolsPath $sitePath

	#Modify initialization module namespace
    $infrastructureSourcePath = Join-Path $toolsPath ".\Infrastructure"
	$infrastructurePath = Join-Path $sitePath "\Infrastructure"

	#Create folder if it does not exist
	New-Item -Force -ItemType Directory -Path $infrastructurePath

	#Copy Infrastructure items, just don't overwrite.
	Get-ChildItem -Path $infrastructureSourcePath | Copy-Item -Destination $infrastructurePath -Recurse -Container

	Add-ProjectItems $project $infrastructurePath
	$initializationModulePath = Join-Path $sitePath "\Infrastructure\EPiServerCommerceInitializationModule.cs"
	Set-NameSpace $initializationModulePath $project.Properties.Item("DefaultNamespace").Value.ToString();

	# Run Script
	Write-Host "Running $($commerceCoreDbPath) into $($uniqueDB)"
	&$deployEXEPath -a sql -s $sitePath -p $commerceCoreDbPath -v false -c "EcfSqlConnection"

	Write-Host "EPiServer.Commerce is installed"
}
