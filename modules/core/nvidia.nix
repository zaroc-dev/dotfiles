{ self, inputs, ... }: {
  flake.nixosModules.nvidia = { config, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    boot = {
      blacklistedKernelModules = [ "nouveau" ];
      # Early KMS: plymouth ignores simpledrm, so without the driver in
      # the initrd the boot splash has no display to draw on.
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      # Saves VRAM across suspend; without it resume ends in Xid 13 and a white screen.
      powerManagement.enable = true;

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.nvidia-container-toolkit.enable = true;

    environment.sessionVariables = {
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # Prevent NVIDIA's EGL buffer pool from retaining close to 1 GiB in
    # niri. This is the application profile recommended by niri upstream.
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
      builtins.toJSON {
        rules = [
          {
            pattern = {
              feature = "procname";
              matches = "niri";
            };
            profile = "Limit Free Buffer Pool On Wayland Compositors";
          }
        ];
        profiles = [
          {
            name = "Limit Free Buffer Pool On Wayland Compositors";
            settings = [
              {
                key = "GLVidHeapReuseRatio";
                value = 0;
              }
            ];
          }
        ];
      };
  };
}
