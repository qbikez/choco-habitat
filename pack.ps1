param(
    [switch][bool] $stable, 
    [ValidateSet("habitat","habitat.portable")]
    $package
)
pushd 

try {
cd $PSScriptRoot
$outdir = ".build"
if (!(test-path $outdir)) { $null = mkdir $outdir }

# 'https://api.bintray.com/content/habitat/stable/windows/x86_64/hab-%24latest-x86_64-windows.zip?bt_package=hab-x86_64-windows'

$pkgBuildNo = "03"
$habitatBaseVer = "0.31.0"
$habitatBuild = "20170907224444"
$habitatVer = "$habitatBaseVer-$habitatBuild"


$specs = "habitat.portable.nuspec","habitat.nuspec" 
if ($package -ne $null) {
    $specs = "$package.nuspec"
}

foreach($specfile in $specs) {
    $nuspec = [xml](gc $specfile)
    $pkgVer = $nuspec.package.metadata.version
    if ($stable) {
        $pkgVer = $habitatBaseVer
    } else {
        $suffix = $habitatBuild.Substring(0,12)
        $pkgVer = "$habitatBaseVer-b$suffix-pkg$($pkgBuildNo)"
    }

    $nuspec.package.metadata.version = $pkgVer
    if ($nuspec.package.metadata.dependencies -ne $null) {
        $dep = $nuspec.package.metadata.dependencies.dependency | ? { $_.id -eq "habitat.portable" }
        if ($dep -ne $null) {
            $dep.version = "[$pkgver]"
        }
    }
    $nuspec.Save((get-item ".").FullName + "\$specfile.tmp")
    mv -fo "$specfile.tmp" "$specfile"
}


# remove comments from chocolateyinstall
$f = ".\tools\_chocolateyinstall.ps1"
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f.Replace("\_","\")

# replace version placeholder (use ruby syntax: #{var})
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '#{hab_version}',$habitatVer } | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f.Replace("\_","\")


# pack
foreach($specfile in $specs) {
    choco pack $specfile -outdir "$outdir"
}
} finally {
popd
}