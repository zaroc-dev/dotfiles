{ ... }: {
  flake.homeModules.gtk = { pkgs, ... }: {
    home.packages = with pkgs; [ adw-gtk3 ];

    gtk = {
      enable = true;
      font = {
        name = "Inter";
        size = 11;
      };
    };

    dconf.settings."org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3-dark";
      color-scheme = "prefer-dark";
      font-name = "Inter 11";
    };
  };
}
