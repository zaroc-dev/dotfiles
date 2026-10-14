{ self, ... }: {
  flake.nixosModules.network = { pkgs, ... }: {
    imports = [
      self.nixosModules.bluetooth
      self.nixosModules.ssh
      self.nixosModules.sshServer
      self.nixosModules.vpn
    ];

    environment.systemPackages = [ pkgs.bind ];
    networking.networkmanager.enable = true;
  };
}
