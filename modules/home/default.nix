{
  self,
  config,
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

  # Feature modules pull in their own home-manager half via
  # `home-manager.users.${username}.imports`; only the user basics live here.
  config.flake.nixosModules.home = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit self inputs; };
      users.${config.username}.imports = [ self.homeModules.zaroc ];
    };
  };
}
