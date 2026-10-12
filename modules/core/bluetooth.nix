{ ... }: {
  flake.nixosModules.bluetooth = { ... }: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # Without a pairing agent (yuki has none) BlueZ turns Pairable off, and a
      # non-pairable adapter pairs without bonding: the device is forgotten on
      # disconnect and can't reconnect.
      settings.General.AlwaysPairable = true;
    };
  };
}
