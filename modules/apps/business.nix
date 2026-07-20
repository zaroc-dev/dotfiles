{ ... }: {
  flake.nixosModules.business = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      thunderbird
      libreoffice
    ];
  };
}
