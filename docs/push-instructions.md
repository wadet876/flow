# Push instructions for flow

This environment may not have authenticated GitHub access.

If push failed here, run these commands locally after signing in:

1. Install git and gh if needed
2. Authenticate
3. Create repo if missing
4. Push

Windows PowerShell command sequence:

winget install --id Git.Git --accept-package-agreements --accept-source-agreements --silent
winget install --id GitHub.cli --accept-package-agreements --accept-source-agreements --silent
gh auth login
gh repo create wadet876/flow --public --source . --remote origin --push

If the repo already exists:

git init
git add .
git commit -m "Add one-shot Neovim bootstrap flow"
git branch -M main
git remote add origin https://github.com/wadet876/flow.git
git push -u origin main
