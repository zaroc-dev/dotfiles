{ inputs, ... }:
{
  flake.nixosModules.boot =
    { pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [
          "quiet"
          "splash"
          "udev.log_level=3"
        ];
        consoleLogLevel = 0;
        initrd.verbose = false;

        loader = {
          systemd-boot.enable = false;
          efi.canTouchEfiVariables = true;

          limine = {
            enable = true;
            efiSupport = true;
            enableEditor = false;
            secureBoot.enable = false; # you can enable secure boot if you are in setup mode

            style = {
              wallpapers = [ ../../wallpapers/alpha_pgr.jpg ];
              wallpaperStyle = "stretched";
              interface.branding = "Alpha OS";
            };
          };
        };

        plymouth = {
          enable = true;
          theme = "mac-style";
          themePackages = [ inputs.mac-style-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default ];
        };
      };

      environment.systemPackages = with pkgs; [
        efibootmgr
        sbctl
      ];
    };
}
