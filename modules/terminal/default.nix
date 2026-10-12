{ self, ... }: {
  flake.nixosModules.terminal = { pkgs, ... }: {
    imports = [ self.nixosModules.zsh ];

    home-manager.users.zaroc.imports = [
      self.homeModules.starship
      self.homeModules.nvim
    ];

    # git, zoxide and neovim come from programs.git, programs.zoxide and nixvim.
    environment.systemPackages = with pkgs; [
      fzf
      fastfetch
      eza
      stow
      ripgrep
      fd
      yazi
      file
      bitwarden-cli

      # yazi previewers
      ffmpeg
      poppler # pdf
      resvg # svg
      imagemagick # imgs HEIC/JPEG
    ];
  };
}
