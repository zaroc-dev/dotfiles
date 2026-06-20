{ inputs, ... }: {
    flake.nixosModules.sddm = { ... } : {
        imports = [ inputs.qylock.nixosModules.default ];      
        services.displayManager.sddm.enable = true;

        programs.qylock = {
            enable = true;
            theme = "wuwa";
            sddm.enable = true;
            quickshell.enable = false;
        };
    };
}