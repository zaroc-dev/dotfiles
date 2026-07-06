{ self, inputs, ... }: {

  flake.nixosConfigurations.hiyuki = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hiyukiConfiguration
      self.nixosModules.boot
      self.nixosModules.sddm
      self.nixosModules.desktop
      self.nixosModules.development
      self.nixosModules.steam
      self.nixosModules.emulators
      self.nixosModules.audio
      self.nixosModules.terminal
      self.nixosModules.bluetooth
      self.nixosModules.vpn
      self.nixosModules.input
      # Apps
      self.nixosModules.apps
      self.nixosModules.ssh
      self.nixosModules.fonts

      # home modules
      self.nixosModules.home
      self.nixosModules.home-desktop
    ];
  };
}
