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
    };
}