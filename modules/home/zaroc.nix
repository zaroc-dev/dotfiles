{ self, ... }: {
  flake.homeModules.zaroc =
    { config, ... }:
    let
      # Writable copy of the repo, outside the read-only Nix store, so apps
      # can write back. Change this if the repo moves.
      dotfiles = "${config.home.homeDirectory}/dotfiles";
    in
    {
      home = {
        username = "zaroc";
        homeDirectory = "/home/zaroc";
        stateVersion = "26.05";

        file = {
          ".config/niri".source = config.lib.file.mkOutOfStoreSymlink dotfiles + /.config/niri;
          ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/kitty";
          "wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wallpapers";
          ".face.icon".source = self + /icons/lilith_icon.gif;
          ".applauncher.png".source = self + /icons/lilith_monochrome_clean.png;
        };

        sessionVariables = {
          EDITOR = "code --wait";
          VISUAL = "code --wait";
          BROWSER = "brave";
        };
      };

      xdg = {
        enable = true;
        configFile."fastfetch".source = "${self}/.config/fastfetch";
      };

      programs.home-manager.enable = true;
    };
}
