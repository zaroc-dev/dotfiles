{
  self,
  ...
}:
{
  config.flake.nixosModules.home-desktop = { ... }: {
    home-manager = {
      users.ruzbyte.imports = [
        self.homeModules.gtk
        self.homeModules.kde
        self.homeModules.icons
        self.homeModules.defaultApps
        self.homeModules.zenBrowser
      ];
    };
  };
}
