{ self, inputs, ... }: {

  flake.nixosConfigurations.acheron = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopHost
      self.nixosModules.acheronConfiguration
    ];
  };
}
