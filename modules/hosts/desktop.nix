{ self, config, ... }:
{
  flake.nixosModules.desktopHost =
    { ... }:
    {
      imports = [
        self.nixosModules.hostCommon
        self.nixosModules.home
        self.nixosModules.boot
        self.nixosModules.audio
        self.nixosModules.network
        self.nixosModules.terminal
        self.nixosModules.desktop
        self.nixosModules.apps
        self.nixosModules.development
        self.nixosModules.gaming
      ];

      services = {
        xserver.xkb = {
          layout = "de";
          variant = "";
        };
        printing.enable = true;
      };

      console.keyMap = "de";

      users.users.${config.username} = {
        isNormalUser = true;
        description = config.username;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
}
