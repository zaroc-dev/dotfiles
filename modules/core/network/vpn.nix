{ ... }: {
  flake.nixosModules.vpn = {
    services.mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };
  };
}
