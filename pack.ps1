
$outdir = ".build"
if (!(test-path $outdir)) { $null = mkdir $outdir }

$f = .\tools\chocolateyinstall.ps1
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f
choco pack -outdir "$outdir"