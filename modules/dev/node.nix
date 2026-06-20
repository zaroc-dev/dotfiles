{ ... }:
{
  flake.nixosModules.javascript = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nodejs
      bun
      pnpm
    ];
  };
}
