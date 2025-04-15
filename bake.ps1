Set-PSDebug -Strict

function bake{
    param(
        [string]$src=".",
        [string]$dst="docs",
        [ScriptBlock]$filter = {
            Param( [string]$src , [string]$dst )
            nkf32 -w $src > $dst
        }
    )
    Set-PSDebug -Strict

    Get-ChildItem -Path $src | ForEach-Object {
        $name = $_.Name
        if ( $name.StartsWith(".") -or $name -eq "docs" -or $name.EndsWith(".ps1") ){
            return
        }
        $newname = (Join-Path -Path $dst -ChildPath $name)
        Write-Host ("{0}`n-> {1}" -f $_.FullName,$newname)
        if ( $_.PSIsContainer ){
            if ( -not (Test-Path $newname) ){
                New-Item -Path $newname -ItemType "Directory"
            }
            bake ($_.FullName) $newname $filter
        } else {
            if ($name -match '\.html?$') {
                & $filter $_.FullName $newname
            } else {
                Copy-Item $_.FullName $newname -Force
            }
        }
    } | Out-Null
}

if ($MyInvocation.InvocationName -ne '.') {
    $from = $(if ($args.Length -gt 1){ $args[0] } else { "." })
    $to   = $(if ($args.Length -gt 2){ $args[1] } else { "docs" })
    bake $from $to
}
