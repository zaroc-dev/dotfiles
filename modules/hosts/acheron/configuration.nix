{ self, inputs, ... }: {

  flake.nixosModules.acheronConfiguration =
    { config, pkgs, ... }:

    {
      imports = [
        self.nixosModules.acheronHardware
      ];

      networking.hostName = "acheron";

      networking.networkmanager.enable = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      time.timeZone = "Europe/Berlin";

      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };

      services.xserver.xkb = {
        layout = "de";
        variant = "";
      };

      console.keyMap = "de";

      services.printing.enable = true;

      security.rtkit.enable = true;

      users.users."ruzbyte" = {
        isNormalUser = true;
        description = "ruzbyte";
        extraGroups = [
          "networkmanager"
          "wheel"
          "kvm"
        ];
        packages = with pkgs; [
          kdePackages.kate
        ];
      };

      programs.firefox.enable = true;

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "26.05";
    };

}
