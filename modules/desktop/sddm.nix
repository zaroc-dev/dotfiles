{ self, inputs, ... }:
{
  flake.nixosModules.sddm =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.displayManager.sddm.wayland;
      westonConfig = (pkgs.formats.ini { }).generate "sddm-weston.ini" {
        output = {
          name = cfg.primaryOutput;
          app-ids = "sddm-greeter,sddm-greeter-qt6";
        };
        keyboard = {
          keymap_model = config.services.xserver.xkb.model;
          keymap_layout = config.services.xserver.xkb.layout;
          keymap_variant = config.services.xserver.xkb.variant;
          keymap_options = config.services.xserver.xkb.options;
        };
        libinput = {
          enable-tap = config.services.libinput.mouse.tapping;
          left-handed = config.services.libinput.mouse.leftHanded;
        };
      };
    in
    {
      imports = [ inputs.yuki.nixosModules.default ];

      options.services.displayManager.sddm.wayland.primaryOutput = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "DP-2";
        description = "Output for the SDDM greeter under Weston's kiosk shell. Null keeps the default output selection.";
      };

      config = {
        programs.yuki = {
          sddm = {
            enable = true;
            background = self + /wallpapers/raiden.shogun.jpg;
          };
          plymouth.enable = true;
        };

        services = {
          displayManager = {
            sddm = {
              enable = true;
              wayland = {
                enable = true;
                # Kiosk-shell routes the greeter's windows by application ID.
                compositorCommand = lib.mkIf (
                  cfg.primaryOutput != null
                ) "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonConfig}";
              };
            };
            defaultSession = "niri";
          };
          gnome.gnome-keyring.enable = true;
        };

        security.pam.services.sddm.enableGnomeKeyring = true;
      };
    };
}
