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

## Wallpapers

Some wallpapers are directly shipped with the dotfiles, after stowing the dotfiles
these are located at `~/wallpapers`
