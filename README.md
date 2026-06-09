# ruzbyte dotfiles

<img width="1916" height="1080" alt="image" src="https://github.com/user-attachments/assets/3b4d3813-543f-404b-ac20-ae5795be540d" />

Dotfiles for Hyprland and Niri (Whatever you prefer)

Some apply for windows, for the Windows configuration refer to the powershell script

## Install

### Linux

Use the Typer-based installer:

```sh
uv run python install.py
```

For a non-interactive install using the defaults:

```sh
uv run python install.py --yes
```

Common opt-ins:

```sh
uv run python install.py --yes --gaming --rust --android --editors neovim,zed,visual-studio-code-bin --browsers brave-bin,zen-browser-bin
```

For Chromium-based browsers, `--chromium-basic-password-store` creates local desktop entries with
`--password-store=basic` to keep sessions persistent across KDE/Niri. Do not use the browser's
built-in password storage with those launchers; use a dedicated password manager instead.

The legacy shell entry point still works and forwards all options:

```sh
./install.sh --help
```

### Windows (WIP)

```sh
ps ./install.ps1
``` 

## Wallpapers

Some wallpapers are directly shipped with the dotfiles, after stowing the dotfiles
these are located at `~/wallpapers` 
