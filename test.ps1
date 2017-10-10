choco upgrade habitat -dv -y -pre --force -s .build

if ($LASTEXITCODE -ne 0) {
    throw "failed to install/upgrade habitat"
}