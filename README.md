# ruzbyte dotfiles

## Install

> [!WARNING]
> Clone into your home directory

```sh
cd ~ && git clone https://github.com/ruzbyte/dotfiles
```

## NixOS

```sh
cd dotfiles && nixos-generate-config --show-hardware-config > ./modules/hosts/<hostname>/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#<host>
```

### Hiyuki

> Gaming PC configuration

```sh
sudo nixos-rebuild switch --flake ~/dotfiles#hiyuki
```

## Other Linux

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

## Wallpapers

Some wallpapers are directly shipped with the dotfiles, after stowing the dotfiles
these are located at `~/wallpapers`
