{ self, ... }: {
  flake.nixosModules.apps = { pkgs, ... }: {
    imports = [
      self.nixosModules.brave
      self.nixosModules.chat
      self.nixosModules.music
      self.nixosModules.business
    ];

    environment.systemPackages = with pkgs; [
      file-roller
      loupe
      nautilus
      papers
    ];

    services.flatpak.enable = true;
  };
}
