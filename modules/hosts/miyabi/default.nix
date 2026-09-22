{ self, inputs, ... }: {
  flake.nixosConfigurations.miyabi = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.hostCommon
      self.nixosModules.miyabiConfiguration
    ];
  };
}
