$ErrorActionPreference = "Stop"
$keyDir = "c:\Users\Wadet\Downloads\flow\keys"
$keyPath = Join-Path $keyDir "flow_github_key"
$pubPath = Join-Path $keyDir "flow_github_key.pub"

New-Item -ItemType Directory -Force -Path $keyDir | Out-Null
if (Test-Path $keyPath) { Remove-Item $keyPath -Force }
if (Test-Path $pubPath) { Remove-Item $pubPath -Force }

# Feed two blank lines to set an empty passphrase non-interactively.
$cmd = '(echo. & echo.) | ssh-keygen -t ed25519 -C "wadet876@users.noreply.github.com" -f "{0}"' -f $keyPath
cmd /c $cmd | Out-Host
