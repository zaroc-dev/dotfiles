{ self, inputs, ... }: {

  flake.nixosConfigurations.hiyuki = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopHost
      self.nixosModules.hiyukiConfiguration
      # self.nixosModules.elden-ring-convergence
      # self.nixosModules.emulators
      self.nixosModules.input
      self.nixosModules.network
    ];
  };
}
