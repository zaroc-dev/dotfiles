{ inputs, ... }: {
  flake.nixosModules.music =
    { pkgs, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      spotify = pkgs.spotify.overrideAttrs (_: {
        version = "1.2.86.502.g8cd7fb22";
        src = pkgs.fetchurl {
          url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_94.snap";
          hash = "sha512-wp+DHLFJM1yWhp2WNCnvUrLJUhdWqB7OvkIuljLNmmlDm0T+0Vt+/zYyx/pGCVqhv5zzMl6e+32hPD/elHMADA==";
        };
      });
      # 2.44.0 currently ships without jsHelper/spicetifyWrapper.js on NixOS,
      # leaving the patched XPUI with `Spicetify is not defined` at startup.
      spicetify = pkgs.spicetify-cli.overrideAttrs (_: {
        version = "2.43.2";
        src = pkgs.fetchFromGitHub {
          owner = "spicetify";
          repo = "cli";
          rev = "v2.43.2";
          hash = "sha256-77OZVDtybkYI5R3tZ7q2cLJ+Ixn8WB4CP4qP6Yp535g=";
        };
        vendorHash = "sha256-uuvlu5yocqnDh6OO5a4Ngp5SahqURc/14fcg1Kr9sec=";
      });
    in
    {
      imports = [ inputs.spicetify-nix.nixosModules.spicetify ];

      programs.spicetify = {
        enable = true;
        spicetifyPackage = spicetify;
        spotifyPackage = spotify;
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
