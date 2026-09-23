# flow

One-shot Neovim bootstrap using kickstart.nvim.

Goal:
- Install required tools
- Download kickstart.nvim
- Create isolated Neovim profile
- Add a reusable launcher
- Open any folder with the new profile

## Quick start

Windows PowerShell:

powershell -ExecutionPolicy Bypass -File .\scripts\onehot.ps1 -ProjectPath "C:\path\to\project"

macOS or Linux:

bash ./scripts/onehot.sh /path/to/project

## What it installs

- git
- neovim
- wezterm (Windows script only, optional)
- curl and unzip (Linux script when needed)

## Result

- Profile name: kickstart-nvim
- Launcher:
  - Windows: %USERPROFILE%\start-kickstart.bat
  - macOS or Linux: ~/.local/bin/start-kickstart

Use launcher from anywhere:

Windows:

start-kickstart.bat "C:\path\to\project"

macOS or Linux:

start-kickstart /path/to/project

## Notes

- Uses the official kickstart.nvim source zip and does not require git clone.
- Keeps your default Neovim config untouched by using NVIM_APPNAME.

## GitHub SSH setup for pushing this repo

Do not commit private keys to git. This repo ignores keys/* by default.

1. Put your key files locally at:
  - keys/flow_github_key
  - keys/flow_github_key.pub
2. Run PowerShell:

powershell -ExecutionPolicy Bypass -File .\scripts\install-github-key.ps1

3. Test SSH:

ssh -T git@github.com

4. Push:

git push -u origin main

## Personal config

- `nvim/`: my Neovim config (lazy.nvim, LSP, treesitter, telescope, oil,
  multicursor, and the `wade-default` / `wade-home` colorschemes). Copy it to
  `~/.config/nvim`.
- `tmux/tmux.conf`: copy to `~/.tmux.conf`. Plugins come from TPM, so clone it
  first: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`,
  then press prefix + I inside tmux. `tmux/tmux-pop` goes in `~/scripts/`
  (executable); prefix + a uses it for the popup.
- `putty/WSL-Ubuntu.reg`: PuTTY session settings (xterm-256color, 24-bit
  colour, xterm-style modified arrow keys, Ctrl-Alt distinct from AltGr). Host,
  port, user name and key file are left blank; import it with
  `reg import putty\WSL-Ubuntu.reg`, then fill those in and save.
