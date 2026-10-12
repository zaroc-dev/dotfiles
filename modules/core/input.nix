{ ... }: {
  flake.nixosModules.input = { ... }: {
    hardware = {
      # Install Wootility and grant device access for the Wooting 80HE.
      wooting.enable = true;
      opentabletdriver.enable = true;
      uinput.enable = true;
    };

    boot = {
      kernelModules = [ "uinput" ];
      # the in-kernel wacom driver grabs the tablet before OpenTabletDriver can
      blacklistedKernelModules = [ "wacom" ];
    };
  };
}
