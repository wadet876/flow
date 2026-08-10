$ErrorActionPreference = "Continue"
Set-Location "C:\Users\Wadet\Downloads\flow"

Write-Host "--- gh auth status ---"
& "C:\Program Files\GitHub CLI\gh.exe" auth status

Write-Host "--- git status -sb ---"
& "C:\Program Files\Git\cmd\git.exe" status -sb

Write-Host "--- git remote -v ---"
& "C:\Program Files\Git\cmd\git.exe" remote -v

Write-Host "--- last commit ---"
& "C:\Program Files\Git\cmd\git.exe" log -1 --oneline --decorate

Write-Host "--- upstream ---"
& "C:\Program Files\Git\cmd\git.exe" rev-parse --abbrev-ref --symbolic-full-name "@{u}"
