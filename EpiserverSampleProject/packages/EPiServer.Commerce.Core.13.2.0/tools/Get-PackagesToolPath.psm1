Function Get-PackagesToolPath($installPath, $package, $version)
{
	return [System.IO.Path]::Combine($installPath, "..", $package + "." + $version , "tools")
}

Export-ModuleMember -function Get-PackagesToolPath
