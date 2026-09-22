{ self, ... }:
{
  flake.nixosModules.desktopHost =
    { ... }:
    {
      imports = [
        self.nixosModules.hostCommon
        self.nixosModules.boot
        self.nixosModules.sddm
        self.nixosModules.desktop
        self.nixosModules.development
        self.nixosModules.steam
        self.nixosModules.osu
        self.nixosModules.audio
        self.nixosModules.terminal
        self.nixosModules.apps
        self.nixosModules.ssh
        self.nixosModules.fonts
        self.nixosModules.bluetooth
        self.nixosModules.vpn
        self.nixosModules.home
        self.nixosModules.home-desktop
      ];

      networking.networkmanager.enable = true;

      services = {
        xserver.xkb = {
          layout = "de";
          variant = "";
        };
        printing.enable = true;
      };

      console.keyMap = "de";

      security.rtkit.enable = true;

      users.users.zaroc = {
        isNormalUser = true;
        description = "zaroc";
        extraGroups = [
          "networkmanager"
          "wheel"
          "kvm"
        ];
      };
    };
}
