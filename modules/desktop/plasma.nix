{
  self,
  inputs,
  config,
  ...
}:
{
  flake = {
    nixosModules.plasma =
      { pkgs, ... }:
      {
        services.desktopManager.plasma6.enable = true;

        environment.systemPackages = [ pkgs.plasma-panel-colorizer ];

        home-manager.users.${config.username}.imports = [ self.homeModules.plasma ];
      };

    homeModules.plasma =
      { config, pkgs, ... }:
      let
        defaultWallpaper = self + /wallpapers/alpha_pgr.jpg;
        catppuccinKde = pkgs.catppuccin-kde.override {
          flavour = [ "mocha" ];
          accents = [ "mauve" ];
        };
        catppuccinKvantum = pkgs.catppuccin-kvantum.override {
          variant = "mocha";
          accent = "mauve";
        };
      in
      {
        imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

        home.packages = [
          catppuccinKde
          catppuccinKvantum
          pkgs.kdePackages.qtstyleplugin-kvantum
          pkgs.libsForQt5.qtstyleplugin-kvantum
        ];

        xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
          [General]
          theme=catppuccin-mocha-mauve
        '';

        programs.plasma = {
          enable = true;
          workspace = {
            iconTheme = "Papirus-Dark";
            clickItemTo = "select";
            colorScheme = "CatppuccinMochaMauve";
            wallpaper = defaultWallpaper;
            cursor = {
              theme = config.home.pointerCursor.name;
              inherit (config.home.pointerCursor) size;
            };
            windowDecorations = {
              library = "org.kde.breeze";
              theme = "Breeze";
            };
          };

          shortcuts = {
            kwin = {
              "Overview" = "Meta+Tab";
              "Window Maximize" = "Meta+Up";
              "Window Quick Tile Left" = "Meta+Left";
              "Window Quick Tile Right" = "Meta+Right";
              "Switch One Desktop to the Right" = "Meta+Shift+Right";
              "Switch One Desktop to the Left" = "Meta+Shift+Left";
            };
            ksmserver."Lock Session" = "Meta+L";
          };
          hotkeys.commands = {
            launch-terminal = {
              name = "Launch Kitty";
              key = "Meta+Return";
              command = "kitty";
            };
            launch-browser = {
              name = "Launch Browser";
              key = "Meta+B";
              command = "brave";
            };
            launch-fuzzel = {
              name = "Launch Applauncher";
              key = "Meta+Space";
              command = "fuzzel";
            };
          };

          kwin = {
            edgeBarrier = 0; # im losing it when my cursor stops between monitors
          };

          panels = [
            {
              location = "bottom";
              floating = false;
              screen = "all";
              height = 44;
              widgets = [
                {
                  name = "luisbocanegra.panel.colorizer";
                  config.General = {
                    hideWidget = true;
                    globalSettings = builtins.toJSON {
                      nativePanel.background = {
                        enabled = false;
                        opacity = 0;
                        shadow = true;
                      };
                    };
                  };
                }
                {
                  name = "org.kde.plasma.kickoff";
                  config.General = {
                    icon = "nix-snowflake-white";
                    alphaSort = true;
                  };
                }
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.pager"
                "org.kde.plasma.spacer"
                {
                  name = "org.kde.plasma.icontasks";
                  config.General.launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:vesktop.desktop"
                    "applications:spotify.desktop"
                    "applications:steam.desktop"
                    "applications:brave-browser.desktop"
                    "applications:systemsettings.desktop"
                  ];
                }
                "org.kde.plasma.spacer"
                "org.kde.plasma.systemtray"
                {
                  name = "org.kde.plasma.digitalclock";
                  config.Appearance.showDate = true;
                }
              ];
            }
          ];

          kscreenlocker = {
            autoLock = true;
            lockOnResume = true;
            timeout = 30;
          };

          configFile = {
            "dolphinrc"."Settings"."HiddenFilesShown" = true;
            "kdeglobals"."KDE"."widgetStyle" = "kvantum";
            # KDE apps keep KWallet, but gnome-keyring stays the Secret Service
            # because it holds Brave's cookie key.
            "kwalletrc"."org.freedesktop.secrets"."apiEnabled" = false;
          };
        };

        # Same override as niri-mimeapps.list; the global default is yazi.
        xdg.configFile."kde-mimeapps.list".text = ''
          [Default Applications]
          inode/directory=org.kde.dolphin.desktop
        '';
      };
  };
}
