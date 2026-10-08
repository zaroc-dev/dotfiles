{ inputs, ... }:
{
  flake.nixosModules.sddm =
    { ... }:
    {
      imports = [ inputs.yuki.nixosModules.default ];

      programs.yuki = {
        sddm = {
          enable = true;
          background = ../../wallpapers/raiden.shogun.jpg;
        };
        plymouth.enable = true;
      };

      services = {
        displayManager = {
          sddm = {
            enable = true;
            wayland.enable = true;
          };
          defaultSession = "niri";
        };
        gnome.gnome-keyring.enable = true;
      };

      security.pam.services.sddm.enableGnomeKeyring = true;
    };
}
