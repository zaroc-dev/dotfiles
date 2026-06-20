{ self, ... }: {
  flake.homeModules.ruzbyte =
    { config, ... }:
    let
      # Writable copy of the repo, outside the read-only Nix store, so apps
      # like noctalia can write back (settings, plugins). Change this if the repo moves.
      dotfiles = "${config.home.homeDirectory}/dotfiles";
    in
    {
      home.username = "ruzbyte";
      home.homeDirectory = "/home/ruzbyte";
      home.stateVersion = "26.05";

      xdg.enable = true;

      xdg.configFile = {
        "nvim".source = "${self}/.config/nvim";
        "fastfetch".source = "${self}/.config/fastfetch";
      };

      home.file.".config/noctalia/".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/noctalia";

      home.file.".config/niri".source = config.lib.file.mkOutOfStoreSymlink dotfiles + /.config/niri;
      home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/kitty";

      programs.home-manager.enable = true;

      home.file.".face.icon" = {
        source = self + /icons/lilith_icon.gif;
      };

      home.file.".applauncher.png" = {
        source = self + /icons/lilith_monochrome_clean.png;
      };

    };
}
