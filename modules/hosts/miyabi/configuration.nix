{ self, inputs, ... }: {
  flake.nixosModules.miyabiConfiguration = { ... }: {

    imports = [
      inputs.nixos-wsl.nixosModules.default

      self.nixosModules.terminal

      self.nixosModules.ssh

      self.nixosModules.docker
      self.nixosModules.javascript
      self.nixosModules.python
      self.nixosModules.git
      self.nixosModules.cli-tools

      self.nixosModules.home
    ];

    networking.hostName = "miyabi";
    system.stateVersion = "26.05";

    wsl = {
      enable = true;
      defaultUser = "zaroc";
    };

    programs.nix-ld.enable = true;
  };
}
