
$ErrorActionPreference = 'Stop';

$packageName= 'habitat.portable'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = ''
$url64      = 'https://api.bintray.com/content/habitat/stable/windows/x86_64/hab-#{hab_version}-x86_64-windows.zip?bt_package=hab-x86_64-windows'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE_MSI_OR_MSU'
  url           = $url
  url64bit      = $url64

  softwareName  = 'habitat*'

  checksum      = ''
  checksumType  = 'sha256'
  checksum64    = ''
  checksumType64= 'sha256'

}


Install-ChocolateyZipPackage @packageArgs










    








