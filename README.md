# zaroc dotfiles

## Install

> [!WARNING]
> Clone into your home directory

```sh
cd ~ && git clone https://github.com/zaroc-dev/dotfiles
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

## Updating Desktop Apps

```sh
nix run .#update-desktop-apps
```

## MATLAB

`packages.x86_64-linux.matlab` provides `matlab`, `matlab-install`,
`matlab-shell`, and a desktop entry. It wraps a separately installed copy of
MATLAB in an FHS environment; the proprietary application is not in the Nix
store. A MathWorks license is required.

Download and extract the Linux installer from
[MathWorks](https://www.mathworks.com/downloads/), then run:

```sh
nix run .#matlab-install -- ~/Downloads/matlab-installer/install
```

Choose `/home/zaroc/.local/share/matlab` as the installation folder in the
installer (or `$HOME/.local/share/matlab` for another user). Then launch:

```sh
nix run .#matlab
```

Set `MATLAB_ROOT` to use an existing installation or a different release:

```sh
MATLAB_ROOT="$HOME/MATLAB/R2026b" nix run .#matlab -- -batch 'disp(version)'
```

`nix run .#matlab-shell` opens the same environment for activation tools or
maintenance. Install MATLAB as your normal user into a writable directory.
