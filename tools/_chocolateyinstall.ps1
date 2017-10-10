$ErrorActionPreference = 'Stop';


$packageName= 'habitat.portable'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = '#{url}'
$checksum   = "#{checksum}"

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










    








