{ ... }: {
  flake.nixosModules.docker = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    # hardware.nvidia-container-toolkit.enable = true;

    users.users.ruzbyte.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      docker-buildx
      docker-compose
    ];
  };
}
