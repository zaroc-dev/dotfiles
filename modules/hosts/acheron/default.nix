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
      self.nixosModules.home
      self.nixosModules.music
      self.nixosModules.chat
      self.nixosModules.browser
      self.nixosModules.misc
      self.nixosModules.ssh
      self.nixosModules.fonts
    ];
  };
}
