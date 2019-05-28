function Remove-EPiCommonFromWebConfig {

	param ([xml]$webConfig)

	$modified = $false

	$commonSectionDeclaration = $webConfig.SelectSingleNode("/configuration/configSections/section[@name='episerver.common']")
	if ($commonSectionDeclaration -ne $null) {
		Write-Host "Removing episerver.common config section declaration."
		$commonSectionDeclaration.ParentNode.RemoveChild($commonSectionDeclaration) | Out-Null
		$modified = $true
	}

	$commonSection = $webConfig.SelectSingleNode("/configuration/episerver.common")
	if ($commonSection -ne $null) {
		Write-Host "Removing episerver.common config section."
		$commonSection.ParentNode.RemoveChild($commonSection) | Out-Null
		$modified = $true
	}

	$nhibernateSectionDeclaration = $webConfig.SelectSingleNode("/configuration/configSections/section[@name='nhibernate']")
	if ($nhibernateSectionDeclaration -ne $null) {
		Write-Host "Removing nhibernate config section declaration."
		$nhibernateSectionDeclaration.ParentNode.RemoveChild($nhibernateSectionDeclaration) | Out-Null
		$modified = $true
	}

	$nhibernateSection = $webConfig.SelectSingleNode("/configuration/nhibernate")
	if ($nhibernateSection -ne $null) {
		Write-Host "Removing nhibernate config section."
		$nhibernateSection.ParentNode.RemoveChild($nhibernateSection) | Out-Null
		$modified = $true
	}

	$hibernateConfigSectionDeclaration = $webConfig.SelectSingleNode("/configuration/configSections/section[@name='hibernate-configuration']")
	if ($hibernateConfigSectionDeclaration -ne $null) {
		Write-Host "Removing hibernate-configuration config section declaration."
		$hibernateConfigSectionDeclaration.ParentNode.RemoveChild($hibernateConfigSectionDeclaration) | Out-Null
		$modified = $true
	}

	$hibernateConfigSection = $webConfig.SelectSingleNode("/configuration/*[local-name()='hibernate-configuration']")
	if ($hibernateConfigSection -ne $null) {
		Write-Host "Removing hibernate-configuration config section."
		$hibernateConfigSection.ParentNode.RemoveChild($hibernateConfigSection) | Out-Null
		$modified = $true
	}

	$ns = @{x = 'urn:schemas-microsoft-com:asm.v1'}
	$bindingRedirects = $webConfig | Select-Xml -Namespace $ns `
		"/configuration/runtime/x:assemblyBinding/x:dependentAssembly[x:assemblyIdentity[starts-with(@name,'EPiServer.Common.')]]"
	if (($bindingRedirects | Measure-Object).Count -gt 0) {
		Write-Host 'Removing assembly binding redirects:'
		$bindingRedirects| Foreach-Object {
			$assemblyName = $_ | Select-Xml "x:assemblyIdentity/@name" -Namespace $ns
			Write-Host "Removing assembly binding redirect for $assemblyName"
			$_.Node.ParentNode.RemoveChild($_.Node) | Out-Null
		}
		$modified = $true
	}

	$roleProviders = $webConfig | Select-Xml "/configuration/system.web/roleManager/providers/add[starts-with(@type, 'EPiServer.Common.')]"
	if (($roleProviders | Measure-Object).Count -gt 0) {
		Write-Host 'Removing EPiServer Common role provider(s):'
		$roleProviders | Foreach-Object {
			$providerName = $_ | Select-Xml "@name"
			Write-Host "Removing role provider $providerName"
			$_.Node.ParentNode.RemoveChild($_.Node) | Out-Null
		}
		$modified = $true
	}

	$membershipProviders = $webConfig | Select-Xml "/configuration/system.web/membership/providers/add[starts-with(@type, 'EPiServer.Common.')]"
	if (($membershipProviders | Measure-Object).Count -gt 0) {
		Write-Host 'Removing EPiServer Common membership provider(s):'
		$membershipProviders | Foreach-Object {
			$providerName = $_ | Select-Xml "@name"
			Write-Host "Removing membership provider $providerName"
			$_.Node.ParentNode.RemoveChild($_.Node) | Out-Null
		}
		$modified = $true
	}

	$httpModules = $webConfig | Select-Xml "/configuration/system.webServer/modules/add[starts-with(@type, 'EPiServer.Common.')]"
	if (($httpModules | Measure-Object).Count -gt 0) {
		Write-Host 'Removing EPiServer Common http module(s):'
		$httpModules | Foreach-Object {
			$moduleName = $_ | Select-Xml "@name"
			Write-Host "Removing http module $moduleName"
			$_.Node.ParentNode.RemoveChild($_.Node) | Out-Null
		}
		$modified = $true
	}

	$commonShellModule = $webConfig.SelectSingleNode("/configuration/episerver.shell/protectedModules/add[@name='EPiServerCommon']")
	if ($commonShellModule -ne $null) {
		Write-Host "Removing EPiServer Common protected shell module."
		$commonShellModule.ParentNode.RemoveChild($commonShellModule) | Out-Null
		$modified = $true
	}

	$commonLocation = $webConfig.SelectSingleNode("/configuration/location[@path='EPiServerCommon']")
	if ($commonLocation -ne $null) {
		Write-Host "Removing EPiServer Common location element."
		$commonLocation.ParentNode.RemoveChild($commonLocation) | Out-Null
		$modified = $true
	}
	
	return $modified
}