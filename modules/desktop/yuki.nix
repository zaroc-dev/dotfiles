{ inputs, ... }:
{
  flake.homeModules.yuki =
    { config, ... }:
    {
      imports = [ inputs.yuki.homeManagerModules.default ];

      programs.yuki = {
        enable = true;
        # Run the live checkout (hot reload) instead of the store copy. Hosts
        # without ~/source/shell fall back to the packaged version (the wrapper
        # checks for shell.qml). Settings are shared either way.
        configDir = "${config.home.homeDirectory}/source/shell";
        gtk.enable = true;
      };
    };
}
