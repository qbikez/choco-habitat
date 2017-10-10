$ErrorActionPreference = 'Stop';


$packageName= 'habitat.portable'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://api.bintray.com/content/habitat/stable/windows/x86_64/hab-0.36.0-20171009043622-x86_64-windows.zip?bt_package=hab-x86_64-windows'
$checksum   = "C9CB888DF134D3AA40D8B68B5174923D32C0E38F76812BE23E327F0CF5F0F865"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE_MSI_OR_MSU'
  url           = $url
  url64bit      = $url64

  softwareName  = 'habitat*'

  checksum      = $checksum
  checksumType  = 'sha256'
}


Install-ChocolateyZipPackage @packageArgs










    








