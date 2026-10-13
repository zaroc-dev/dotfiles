{ self, config, ... }:
let
  name = "ye-shunguang-zzz-cursors";
  size = 24;
  packageFor = pkgs: pkgs.callPackage (self + /packages/ye-shunguang-cursors.nix) { };
in
{
  flake = {
    nixosModules.cursor =
      { pkgs, ... }:
      let
        package = packageFor pkgs;
        cursorEnvironment = {
          XCURSOR_THEME = name;
          XCURSOR_SIZE = toString size;
        };
      in
      {
        environment = {
          systemPackages = [
            package
            (pkgs.writeTextDir "share/icons/default/index.theme" ''
              [Icon Theme]
              Inherits=${name}
            '')
          ];
          variables = cursorEnvironment;
        };

        services.displayManager.sddm.settings.Theme = {
          CursorTheme = name;
          CursorSize = size;
        };

        systemd.services.display-manager.environment = cursorEnvironment // {
          XCURSOR_PATH = "${package}/share/icons";
        };

        home-manager.users.${config.username}.imports = [ self.homeModules.cursor ];
      };

    homeModules.cursor =
      { pkgs, ... }:
      {
        home.pointerCursor = {
          enable = true;
          inherit name size;
          package = packageFor pkgs;
          gtk.enable = true;
          x11.enable = true;
        };

        gtk.enable = true;

        dconf.settings."org/gnome/desktop/interface" = {
          cursor-theme = name;
          cursor-size = size;
        };
      };
  };
}
