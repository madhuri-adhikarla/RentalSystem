Function Get-Config($configPath)
{
	$config = New-Object xml
	$config.psbase.PreserveWhitespace = $true
	$config.Load($configPath) | Out-Null
	$config
}

Export-ModuleMember -function Get-Config