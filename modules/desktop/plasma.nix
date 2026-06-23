{ ... }: {
  flake.nixosModules.plasma = { pkgs, ... }: {
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = [ pkgs.plasma-panel-colorizer ];
  };
}
