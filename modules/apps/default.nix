{ self, ... }: {
  flake.nixosModules.apps = { ... }: {
    imports = [
      self.nixosModules.brave
      self.nixosModules.chat
      self.nixosModules.music
      self.nixosModules.business
    ];

    services.flatpak.enable = true;
  };
}
