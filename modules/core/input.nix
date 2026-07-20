{ ... }: {
  flake.nixosModules.input = { ... }: {
    hardware.opentabletdriver.enable = true;
    hardware.uinput.enable = true;

    # OpenTabletDriver otherwise races niri during login, falls back to X11
    # before either display socket exists, and crashes in XDefaultRootWindow.
    systemd.user.services.opentabletdriver.after = [ "niri.service" ];

    boot.kernelModules = [ "uinput" ];
    # the in-kernel wacom driver grabs the tablet before OpenTabletDriver can
    boot.blacklistedKernelModules = [ "wacom" ];
  };
}
