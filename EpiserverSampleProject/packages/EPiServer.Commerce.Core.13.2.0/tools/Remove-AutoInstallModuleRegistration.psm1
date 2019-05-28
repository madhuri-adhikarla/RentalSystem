##
## Remove registration for AutoInstallMetaDataModule
##
Function Remove-AutoInstallModuleRegistration([System.Xml.XmlDocument]$config)
{
    $autoInstallModules = $config.SelectNodes("/businessManager/plugins/add[contains(@type,'AutoInstallMetaDataModule, Mediachase.Commerce')]")
    $plugins = $config.SelectSingleNode("/businessManager/plugins")
    foreach($autoInstallModule in $autoInstallModules)
    {
        $plugins.RemoveChild($autoInstallModule)
    }
}