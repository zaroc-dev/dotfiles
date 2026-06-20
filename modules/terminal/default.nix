{ ... }: {
  flake.nixosModules.terminal = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      kitty
      foot
      fzf
      neovim
      git
      fastfetch
      eza
      zoxide
      yazi
      stow
    ];
  };
}
