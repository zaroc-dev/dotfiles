{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
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
        chatgpt-desktop = pkgs.callPackage ../packages/chatgpt-desktop.nix { };
        claude-desktop = pkgs.callPackage ../packages/claude-desktop.nix { };
        t3code-nightly = pkgs.callPackage ../packages/t3code-nightly.nix { };
        update-desktop-apps = updateDesktopApps;
      };

      apps.update-desktop-apps = {
        type = "app";
        program = "${updateDesktopApps}/bin/update-desktop-apps";
      };
    };
}
