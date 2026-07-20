{ self, ... }: {
  flake.nixosModules.apps = { ... }: {
    imports = [
      self.nixosModules.chat
      self.nixosModules.music
      self.nixosModules.business
      self.nixosModules.luminotes
    ];
  };
}
