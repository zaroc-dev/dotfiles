{ self, inputs, ... }: {

  flake.nixosConfigurations.hiyuki = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hiyukiConfiguration
      self.nixosModules.boot
      self.nixosModules.sddm
      self.nixosModules.desktop
      self.nixosModules.development
      self.nixosModules.gaming
      self.nixosModules.audio
      self.nixosModules.terminal
      self.nixosModules.home
      self.nixosModules.music
      self.nixosModules.chat
      self.nixosModules.browser
      self.nixosModules.misc
      self.nixosModules.ssh
    ];
  };
}
