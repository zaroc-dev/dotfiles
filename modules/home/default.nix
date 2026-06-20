{
  self,
  inputs,
  lib,
  ...
}:
{
  # flake-parts declares an option for `flake.nixosModules` (so definitions
  # across files merge), but not for `homeModules`. Declare it once here.
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = "home-manager modules exposed by this flake.";
  };

  config.flake.nixosModules.home = { pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    programs.zsh.enable = true;
    users.users.ruzbyte.shell = pkgs.zsh;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit self inputs; };
      users.ruzbyte.imports = [
        self.homeModules.ruzbyte
        self.homeModules.zsh
        self.homeModules.starship
        self.homeModules.dotnet
        self.homeModules.git
      ];
    };
  };
}
