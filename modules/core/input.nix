{ ... }: {
  flake.nixosModules.input = { ... }: {
    # Install Wootility and grant device access for the Wooting 80HE.
    hardware.wooting.enable = true;
    hardware.opentabletdriver.enable = true;
    hardware.uinput.enable = true;

    boot.kernelModules = [ "uinput" ];
    # the in-kernel wacom driver grabs the tablet before OpenTabletDriver can
    boot.blacklistedKernelModules = [ "wacom" ];
  };
}
