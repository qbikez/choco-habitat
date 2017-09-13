
$ErrorActionPreference = 'Stop';

$packageName= 'habitat.portable'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://api.bintray.com/content/habitat/stable/windows/x86_64/hab-#{hab_version}-x86_64-windows.zip?bt_package=hab-x86_64-windows'
$checksum   = "9AF0525CAB1027073D6F6D303239EF1F4EFCC99676F502F1B87CA77C640FE6AB"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE_MSI_OR_MSU'
  url           = $url
  url64bit      = $url64

  softwareName  = 'habitat*'

  checksum      = ''
  checksumType  = 'sha256'
}


Install-ChocolateyZipPackage @packageArgs










    








