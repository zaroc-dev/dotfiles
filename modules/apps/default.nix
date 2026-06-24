{ self, ... }: {
  flake.nixosModules.apps = { ... }: {
    imports = [
      self.nixosModules.browser
      self.nixosModules.chat
      self.nixosModules.music
      self.nixosModules.misc
    ];
  };
}
