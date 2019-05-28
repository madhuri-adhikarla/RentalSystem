##
## Remove registration for Mediachase.Commerce.Marketing.Validators
##
Function Remove-MarketingConfiguration([System.Xml.XmlDocument]$config)
{
    $filterExpressions = $config.SelectNodes("/BusinessFoundationSettings/filterExpressionProviders/add[contains(@type,'Mediachase.Commerce.Marketing.Validators')]")
    $providers = $config.SelectSingleNode("/BusinessFoundationSettings/filterExpressionProviders")
    foreach($filterExpression in $filterExpressions)
    {
        $providers.RemoveChild($filterExpression)
    }

    $businessFoundationSettings = $config.SelectSingleNode("/BusinessFoundationSettings");
    if ($businessFoundationSettings.filterExpressionDefaultProvider -eq "CustomerDataProvider")
    {
        $businessFoundationSettings.SetAttribute("filterExpressionDefaultProvider", "MetaDataProvider");
    }

    $marketingModule = $config.SelectSingleNode("/BusinessFoundationSettings/fileResolverModules/add[@name,'Marketing']")
    if ($marketingModule) 
    {
        $marketingModule.Parent.RemoveChild($marketingModule)
    }
}