# Packages 

* *habitat.portable* - the "real" package that installs habitat
* *habitat* - a meta package with dependency on *habitat.portable*


# Pushing new version

1. update `$pkgBuildNo`,`$habitatBaseVer` and `$habitatBuild` variables in `version.ps1`
2. Run `.\pack.ps1` to create nuget package. Use `-stable` switch to produce stable package version. (This will generate `tools\chocolateyinstall.ps1` from a template file `tools\_chocolateyinstall.ps1`.)
3. Run `.\test.ps1` to verify package installation on local system.
4. Run `.\push.ps1` to push nuget to chocolatey.

