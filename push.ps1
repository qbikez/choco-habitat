param(
    [ValidateSet("habitat","habitat.portable")]
    $package
)

$pkgdir = ".build"

$specs = "habitat.portable.nuspec","habitat.nuspec"

if ($package -ne $null) {
    $specs = "$package.nuspec"
}
 
foreach($specfile in $specs) {
    $pkgname = $specfile -replace ".nuspec",""
    $latest = gci $pkgdir -Filter "$pkgname*.nupkg" | sort LastWriteTime -Descending | select -first 1
    write-host "pushing '$($latest.fullname)'"
    choco push $latest.fullname --source https://push.chocolatey.org/
}
