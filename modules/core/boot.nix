{ ... }: {
  flake.nixosModules.boot = { pkgs, ... }: {
    boot.loader.systemd-boot.enable = false;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.limine = {
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

    boot.plymouth.enable = true;
    boot.kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
    ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;

    environment.systemPackages = with pkgs; [
      efibootmgr
      sbctl
    ];
  };
}
