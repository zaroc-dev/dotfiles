{ ... }: {
  flake.nixosModules.steam = { pkgs, ... }: {
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      # basic packages
      lutris
      mangohud
      protonplus
      protontricks
      wineWow64Packages.stagingFull
      winetricks

      prismlauncher
    ];

  };
}
