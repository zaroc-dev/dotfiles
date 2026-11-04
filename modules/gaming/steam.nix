{ config, ... }: {
  flake.nixosModules.steam = { pkgs, ... }: {
    programs.steam.enable = true;

    hardware.steam-hardware.enable = true;

    # Lutris' compatibility runtime still includes GTK2 for older games.
    nixpkgs.config.problems.handlers."gtk+".broken = "warn";

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

    users.users.${config.username}.extraGroups = [ "input" ];
  };
}
