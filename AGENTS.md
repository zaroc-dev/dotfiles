# Dotfiles

This repository consists of a NixOS Flake with 3 different hosts. As well as other symlinked configurations in .config

## NixOS Config Style

The config is written in a dendritic style, do not ever brake this.
A module is declared as

```nix
flake.homeModules.xyz = { ... }: {};
flake.nixosModules.xyz = { ... }: {};
```

And imported either per host for specifics or generally for multi-modules in a default.nix

Files are grouped by feature, not by nixos/home-manager. A feature that needs both
declares them side by side (`flake = { nixosModules.x = ...; homeModules.x = ...; };`)
and the nixos half pulls in its own home half via
`home-manager.users.zaroc.imports = [ self.homeModules.x ];`, so enabling the
nixos module is all a host needs. Import every homeModule exactly once.

Layout:

- modules
    - apps: shared default desktop apps
    - core: core system configurations like drivers
    - desktop: actual desktop (kde/niri) that is beeing used
    - dev: development environment for hosts
    - gaming: gaming packages and configs
    - home: home-manager bootstrap and user basics (feature HM modules live with their feature)
    - hosts: actual host configs
    - terminal: just a bunch of terminal apps

## Hosts

- miyabi: wsl host
- hiyuki: main machine, nvidia 40xx card, intel cpu
- acheron: intel convertible laptop

## Rules

- Never run `nix build` on your own, you may use `nix eval` or `nix flake check` for validation.
- Never ever load anything via `nix profile` or `nix-env`.

- Group attribute sets, nest them instead of declaring a set multiple times
 - Preferred: set = { opt1 = true; opt2 = true; };
 - Discouraged: set.opt1 = true; set.opt2 = true;


- Code Formatting: Always use nixfmt to clean up and format Nix code after editing.

## Packages

`nixpkgs` on unstable is the default for larger-one
