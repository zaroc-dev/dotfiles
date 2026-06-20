{ ... }: {
  flake.nixosModules.chat = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vesktop
      teams-for-linux
    ];
  };
}
