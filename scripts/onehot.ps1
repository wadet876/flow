param(
  [string]$ProjectPath = (Get-Location).Path,
  [string]$ProfileName = "kickstart-nvim",
  [switch]$SkipWezTermInstall
)

$ErrorActionPreference = "Stop"

function Require-Command([string]$Name) {
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Missing command: $Name"
  }
}

function Ensure-WingetPackage([string]$CommandName, [string]$WingetId, [string]$DisplayName) {
  if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
    Write-Host "$DisplayName already installed"
    return
  }

  Write-Host "Installing $DisplayName via winget"
  winget install --id $WingetId --accept-package-agreements --accept-source-agreements --silent
}

Require-Command winget

Ensure-WingetPackage -CommandName git -WingetId Git.Git -DisplayName Git
Ensure-WingetPackage -CommandName nvim -WingetId Neovim.Neovim -DisplayName Neovim
if (-not $SkipWezTermInstall) {
  if (-not (Get-Command wezterm -ErrorAction SilentlyContinue) -and -not (Test-Path "C:\Program Files\WezTerm\wezterm.exe")) {
    Write-Host "Installing WezTerm via winget"
    winget install --id wez.wezterm --accept-package-agreements --accept-source-agreements --silent
  } else {
    Write-Host "WezTerm already installed"
  }
}

$sourceDir = Join-Path $env:LOCALAPPDATA "kickstart-source"
$profileDir = Join-Path $env:LOCALAPPDATA $ProfileName
$tempZip = Join-Path $env:TEMP "kickstart.nvim-master.zip"
$tempExpanded = Join-Path $env:TEMP "kickstart.nvim-master"

if (Test-Path $tempZip) { Remove-Item $tempZip -Force }
if (Test-Path $tempExpanded) { Remove-Item $tempExpanded -Recurse -Force }

Write-Host "Downloading kickstart.nvim"
Invoke-WebRequest -Uri "https://codeload.github.com/nvim-lua/kickstart.nvim/zip/refs/heads/master" -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $env:TEMP -Force

if (-not (Test-Path $tempExpanded)) {
  throw "Failed to extract kickstart.nvim"
}

if (Test-Path $sourceDir) { Remove-Item $sourceDir -Recurse -Force }
New-Item -ItemType Directory -Path $sourceDir -Force | Out-Null
Get-ChildItem -Path $tempExpanded -Force | ForEach-Object {
  Copy-Item $_.FullName -Destination $sourceDir -Recurse -Force
}

if (Test-Path $profileDir) { Remove-Item $profileDir -Recurse -Force }
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
$exclude = @('.git', '.github', '.gitignore', 'LICENSE.md', 'README.md')
Get-ChildItem -Path $sourceDir -Force | Where-Object { $exclude -notcontains $_.Name } | ForEach-Object {
  Copy-Item $_.FullName -Destination (Join-Path $profileDir $_.Name) -Recurse -Force
}

$launcherPs1 = Join-Path $env:USERPROFILE "start-kickstart.ps1"
$launcherBat = Join-Path $env:USERPROFILE "start-kickstart.bat"
$launcherPs1Body = @"
param(
  [string]`$Target = (Get-Location).Path
)

`$env:NVIM_APPNAME = \"$ProfileName\"
`$wezterm = `$null
`$wezCmd = Get-Command wezterm -ErrorAction SilentlyContinue
if (`$wezCmd) {
  `$wezterm = `$wezCmd.Source
} elseif (Test-Path \"C:\Program Files\WezTerm\wezterm.exe\") {
  `$wezterm = \"C:\Program Files\WezTerm\wezterm.exe\"
}

Push-Location `$Target
try {
  if (`$wezterm) {
    & `$wezterm start --cwd `$Target nvim .
  } else {
    nvim .
  }
}
finally {
  Pop-Location
}
"@
$launcherBatBody = "@echo off`r`nsetlocal`r`npowershell -NoProfile -ExecutionPolicy Bypass -File `"$launcherPs1`" %*`r`n"
Set-Content -Path $launcherPs1 -Value $launcherPs1Body -Encoding ASCII
Set-Content -Path $launcherBat -Value $launcherBatBody -Encoding ASCII

$env:NVIM_APPNAME = $ProfileName
Write-Host "Setup complete"
Write-Host "Profile: $profileDir"
Write-Host "Launcher: $launcherBat"

if (Test-Path "C:\Program Files\WezTerm\wezterm.exe") {
  & "C:\Program Files\WezTerm\wezterm.exe" start --cwd $ProjectPath nvim .
} else {
  Push-Location $ProjectPath
  try { nvim . } finally { Pop-Location }
}
