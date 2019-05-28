##
## Remove custom IE header in httpProtocol 
##
Function Remove-CustomIEHeader([System.Xml.XmlDocument]$config)
{
    $customerIEHeader = $config.SelectSingleNode("configuration/system.webServer/httpProtocol/customHeaders/add[@name='X-UA-Compatible']")
    if($customerIEHeader.value -eq 'IE=7')
    {
        $customerIEHeader.ParentNode.RemoveChild($customerIEHeader);
    }
}

Export-ModuleMember -function Remove-CustomIEHeader
