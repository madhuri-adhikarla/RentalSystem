function Set-CommerceManagerSearchIndexBasePath([xml]$xml, $SearchIndexBasePath)
{
    $xml.InnerXml = $xml.InnerXml.Replace("SEARCH_INDEX_NETWORK_PATH", $SearchIndexBasePath)
}