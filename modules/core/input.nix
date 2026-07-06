{ ... }: {
  flake.nixosModules.input = { ... }: {
    hardware.opentabletdriver.enable = true;
    hardware.uinput.enable = true;

    boot.kernelModules = [ "uinput" ];
    # the in-kernel wacom driver grabs the tablet before OpenTabletDriver can
    boot.blacklistedKernelModules = [ "wacom" ];
  };
}
