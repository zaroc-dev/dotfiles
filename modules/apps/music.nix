{ inputs, ... }: {
  flake.nixosModules.music =
    { pkgs, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      imports = [ inputs.spicetify-nix.nixosModules.spicetify ];

      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;

        colorScheme = "mocha";

        enabledExtensions = with spicePkgs.extensions; [
          hidePodcasts
          shuffle
          fullAppDisplay
        ];
      };
    };
}
