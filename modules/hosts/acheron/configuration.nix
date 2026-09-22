{ self, ... }:
{
  flake.nixosModules.acheronConfiguration =
    { ... }:
    {
      imports = [ self.nixosModules.acheronHardware ];

      networking.hostName = "acheron";
      system.stateVersion = "26.05";
    };
}
