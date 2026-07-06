{ self, inputs, ... }: {

  flake.nixosConfigurations.acheron = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.acheronConfiguration
      self.nixosModules.boot
      self.nixosModules.sddm
      self.nixosModules.desktop
      self.nixosModules.development
      self.nixosModules.steam
      self.nixosModules.audio
      self.nixosModules.terminal
      self.nixosModules.apps
      self.nixosModules.ssh
      self.nixosModules.fonts
      self.nixosModules.bluetooth
      self.nixosModules.vpn
      # home modules
      self.nixosModules.home
      self.nixosModules.home-desktop
    ];
  };
}
