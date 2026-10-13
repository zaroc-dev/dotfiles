{ self, config, ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    imports = [
      self.nixosModules.niri
      self.nixosModules.sddm
      self.nixosModules.fonts
      self.nixosModules.avatar
      self.nixosModules.cursor
    ];

    home-manager.users.${config.username}.imports = [
      self.homeModules.yuki
      self.homeModules.gtk
      self.homeModules.icons
    ];

    environment.systemPackages = [ pkgs.gpu-screen-recorder ];
  };
}
