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
