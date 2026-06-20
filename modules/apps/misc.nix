{ ... }: {
  flake.nixosModules.misc = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [

    ];
  };
}
