$ErrorActionPreference = "Stop"
Set-Location "C:\Users\Wadet\Downloads\flow"

& "C:\Program Files\GitHub CLI\gh.exe" auth status
& "C:\Program Files\Git\cmd\git.exe" status -sb
& "C:\Program Files\Git\cmd\git.exe" remote -v
& "C:\Program Files\Git\cmd\git.exe" push -u origin main
