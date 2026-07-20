{ self, inputs, ... }: {
    flake.nixosModules.nvidia = { config, ... }: {
        services.xserver.videoDrivers = [ "nvidia"];
        boot.blacklistedKernelModules = [ "nouveau" ];

        hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;

            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };

        environment.sessionVariables = {
            NVD_BACKEND = "direct";
            LIBVA_DRIVER_NAME = "nvidia";
        };

        # Prevent NVIDIA's EGL buffer pool from retaining close to 1 GiB in
        # niri. This is the application profile recommended by niri upstream.
        environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = builtins.toJSON {
            rules = [{
                pattern = {
                    feature = "procname";
                    matches = "niri";
                };
                profile = "Limit Free Buffer Pool On Wayland Compositors";
            }];
            profiles = [{
                name = "Limit Free Buffer Pool On Wayland Compositors";
                settings = [{
                    key = "GLVidHeapReuseRatio";
                    value = 0;
                }];
            }];
        };
    };
}
