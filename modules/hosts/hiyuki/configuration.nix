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
      system.stateVersion = "26.05";
    };
}
