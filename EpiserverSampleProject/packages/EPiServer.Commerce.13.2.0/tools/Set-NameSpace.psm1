Function Set-NameSpace($classPath, $nameSpace)
{
	$classContent = Get-Content -path $classPath
	$classContent = $classContent -replace "{projectname}", $($nameSpace)
	Set-Content $classContent -path $classPath
}
Export-ModuleMember -Function Set-NameSpace