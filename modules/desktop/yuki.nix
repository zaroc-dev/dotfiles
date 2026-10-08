{ inputs, ... }:
{
  flake.homeModules.yuki =
    { config, ... }:
    {
      imports = [ inputs.yuki.homeManagerModules.default ];

      programs.yuki = {
        enable = true;
        # Run the live checkout (hot reload) instead of the store copy.
        # Remove to use the packaged version. Settings are shared either way.
        configDir = "${config.home.homeDirectory}/source/shell";
        gtk.enable = true;
      };
    };
}
