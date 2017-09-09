$pkgdir = ".build"
$latest = gci $pkgdir -Filter "*.nupkg" | sort LastWriteTime -Descending | select -first 1

choco push $latest.fullname --source https://push.chocolatey.org/