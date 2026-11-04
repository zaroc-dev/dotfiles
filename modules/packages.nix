{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      matlab = pkgs.callPackage ../packages/matlab.nix { };
      updateDesktopApps = pkgs.writeShellApplication {
        name = "update-desktop-apps";
        runtimeInputs = with pkgs; [
          coreutils
          curl
          gawk
          git
          gnused
          gzip
          jq
          nix
          nixfmt
          rpm
        ];
        text = builtins.readFile ../packages/update-desktop-apps.sh;
      };
    in
    {
      packages = {
        inherit matlab;
        chatgpt-desktop = pkgs.callPackage ../packages/chatgpt-desktop.nix { };
        claude-desktop = pkgs.callPackage ../packages/claude-desktop.nix { };
        t3code-nightly = pkgs.callPackage ../packages/t3code-nightly.nix { };
        update-desktop-apps = updateDesktopApps;
      };

      apps = {
        matlab-install = {
          type = "app";
          program = "${matlab}/bin/matlab-install";
        };
        matlab-shell = {
          type = "app";
          program = "${matlab}/bin/matlab-shell";
        };
        update-desktop-apps = {
          type = "app";
          program = "${updateDesktopApps}/bin/update-desktop-apps";
        };
      };
    };
}
