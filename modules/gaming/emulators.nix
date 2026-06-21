{ ... }: {
    flake.nixosModules.emulators = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        # Emulators
        shadps4
        ryubing
      ];
    };
}