param(
  [string]$PrivateKeyPath = "./keys/flow_github_key",
  [string]$PublicKeyPath = "./keys/flow_github_key.pub"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$privateSrc = Resolve-Path (Join-Path $repoRoot $PrivateKeyPath)
$publicSrc = Resolve-Path (Join-Path $repoRoot $PublicKeyPath)

$sshDir = Join-Path $env:USERPROFILE ".ssh"
New-Item -ItemType Directory -Force -Path $sshDir | Out-Null

$privateDst = Join-Path $sshDir "flow_github_key"
$publicDst = Join-Path $sshDir "flow_github_key.pub"
$configPath = Join-Path $sshDir "config"

Copy-Item $privateSrc $privateDst -Force
Copy-Item $publicSrc $publicDst -Force

$cfgBlock = @'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/flow_github_key
    IdentitiesOnly yes
'@

if (Test-Path $configPath) {
  $existing = Get-Content -Path $configPath -Raw
  if ($existing -notmatch 'IdentityFile ~/.ssh/flow_github_key') {
    Add-Content -Path $configPath -Value "`r`n$cfgBlock"
  }
} else {
  Set-Content -Path $configPath -Encoding ASCII -Value $cfgBlock
}

Write-Host "Installed SSH key files for GitHub."
Write-Host "Now run: ssh -T git@github.com"
