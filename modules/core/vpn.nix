{ ... }: {
  flake.nixosModules.vpn = { pkgs, ... }: {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
