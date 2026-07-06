{ inputs, ... }: {
  flake.nixosModules.luminotes = { pkgs, ... }: {
    environment.systemPackages = [
      inputs.luminotes.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
