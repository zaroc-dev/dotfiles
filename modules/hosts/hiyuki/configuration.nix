{ self, ... }:
{
  flake.nixosModules.hiyukiConfiguration =
    { ... }:
    {
      imports = [
        self.nixosModules.hiyukiHardware
        self.nixosModules.nvidia
      ];

      networking.hostName = "hiyuki";

      services.displayManager.sddm.wayland.primaryOutput = "DP-2";

      system.stateVersion = "26.05";
    };
}
