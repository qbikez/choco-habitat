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

. "$PSScriptRoot\version.ps1"

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


$url = "https://api.bintray.com/content/habitat/stable/windows/x86_64/hab-$habitatVer-x86_64-windows.zip?bt_package=hab-x86_64-windows"
$file = "hab-$habitatVer-x86_64-windows.zip"
if (!(test-path $file)) {
    Invoke-WebRequest $url -UseBasicParsing -OutFile $file
}
$checksum = (get-filehash -Path $file -Algorithm sha256).hash


$files = @(".\tools\_chocolateyinstall.ps1")

foreach($f in $files) {
        
    gc $f | ? {$_ -notmatch "^\s*#"} | 
        % { $_ -replace '#{url}',$url } | # replace version placeholder (use ruby-like syntax: #{var})
        % { $_ -replace '#{checksum}',$checksum } |
        % { $_ -replace '(^.*?)\s*?[^``]#.*','$1' } | # remove comments 
        Out-File ($f+".~") -en utf8
    
    move-item ($f+".~") $f.Replace("\_","\") -Force 
}

# pack
foreach($specfile in $specs) {
    choco pack $specfile -outdir "$outdir"
}
} finally {
popd
}