{ ... }: {
  flake.nixosModules.network = { ... }: {
    networking = {
      interfaces = {
        enp5s0 = {
          wakeOnLan.enable = true;
        };
      };

      firewall = {
        allowedUDPPorts = [ 9 ];
        allowedTCPPorts = [ 22 ];
      };
    };

    services.openssh.enable = true;
  };
}
