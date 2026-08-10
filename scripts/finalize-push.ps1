$ErrorActionPreference = "Stop"
Set-Location "C:\Users\Wadet\Downloads\flow"

if (Test-Path ".\keys\flow_github_key") { Remove-Item ".\keys\flow_github_key" -Force }
if (Test-Path ".\keys\flow_github_key.pub") { Remove-Item ".\keys\flow_github_key.pub" -Force }

& "C:\Program Files\Git\cmd\git.exe" add .

$changes = & "C:\Program Files\Git\cmd\git.exe" status --porcelain
if ($changes) {
  & "C:\Program Files\Git\cmd\git.exe" commit -m "Secure keys and finalize flow bootstrap"
}

& "C:\Program Files\Git\cmd\git.exe" push -u origin main
& "C:\Program Files\Git\cmd\git.exe" status -sb
& "C:\Program Files\Git\cmd\git.exe" log -1 --oneline --decorate
