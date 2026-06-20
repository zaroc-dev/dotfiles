{
  ...
}:
{
  flake.nixosModules.java = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      jdk21
      maven
      jetbrains.idea
    ];
  };
}
