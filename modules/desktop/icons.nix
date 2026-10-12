{ ... }: {
  flake.homeModules.icons = { pkgs, ... }: {
    home.packages = [
      (pkgs.papirus-icon-theme.override { color = "blue"; })
    ];

    dconf.settings."org/gnome/desktop/interface".icon-theme = "Papirus-Dark";
  };
}
