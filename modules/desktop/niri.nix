{ ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs = {
      niri.enable = true;
      noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      kitty
      wl-clipboard
      cliphist
      xwayland-satellite
      fuzzel
    ];
  };
}
