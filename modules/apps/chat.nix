{ ... }: {
  flake.nixosModules.chat = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      teams-for-linux
      vesktop
    ];
  };
}
