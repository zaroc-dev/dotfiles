{ ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;

    # Battery and power profile state for yuki's bar.
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
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
