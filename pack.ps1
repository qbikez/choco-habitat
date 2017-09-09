
$outdir = ".build"
if (!(test-path $outdir)) { $null = mkdir $outdir }

# 'https://api.bintray.com/content/habitat/stable/windows/x86_64/hab-%24latest-x86_64-windows.zip?bt_package=hab-x86_64-windows'

$pkgBuildNo = "02"
$habitatVer = "0.31.0-20170907224444"

$nuspec = [xml](gc ".\habitat.portable.nuspec")
$pkgVer = $nuspec.package.metadata.version
$pkgVer = "0.31.0-b201709072244-pkg$($pkgBuildNo)"

$nuspec.package.metadata.version = $pkgVer
$nuspec.Save((get-item ".").FullName + "\habitat.portable.nuspec.tmp")

# remove comments from chocolateyinstall
$f = ".\tools\_chocolateyinstall.ps1"
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f.Replace("\_","\")

# replace version placeholder (use ruby syntax: #{var})
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '#{hab_version}',$habitatVer } | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f.Replace("\_","\")


mv -fo ".\habitat.portable.nuspec.tmp" ".\habitat.portable.nuspec"

# pack
choco pack -outdir "$outdir"