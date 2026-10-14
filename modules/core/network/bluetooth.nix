{ ... }: {
  flake.nixosModules.bluetooth = { ... }: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # Allow pairing even before the desktop pairing agent starts.
      settings.General.AlwaysPairable = true;
    };
  };
}
