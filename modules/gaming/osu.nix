{ ... }: {
  flake.nixosModules.osu = { pkgs, ... }: let
    # osu! picks x11 by default, which on niri goes through xwayland-satellite:
    # relative mouse mode gets stuck in the top-left and drag & drop doesn't work
    osu-lazer = pkgs.symlinkJoin {
      name = "osu-lazer-bin-wayland";
      paths = [ pkgs.osu-lazer-bin ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/osu!" --set SDL_VIDEODRIVER wayland

        # %u spawns one process per selected file, and a burst of those all
        # hitting the running game's IPC at once times out and crashes.
        # %U hands every file to a single process, which imports them in order.
        desktop="$out/share/applications/osu!.desktop"
        cp --remove-destination "$(readlink -f "$desktop")" "$desktop"
        substituteInPlace "$desktop" --replace-fail "Exec=osu! %u" "Exec=osu! %U"
      '';
    };

    # the AppImage ships a .desktop file claiming these types but never defines
    # them, so .osk/.osz files are detected as plain zip archives
    osu-mime = pkgs.writeTextDir "share/mime/packages/osu.xml" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/x-osu-beatmap-archive">
          <comment>osu! beatmap archive</comment>
          <sub-class-of type="application/zip"/>
          <glob pattern="*.osz"/>
        </mime-type>
        <mime-type type="application/x-osu-skin-archive">
          <comment>osu! skin archive</comment>
          <sub-class-of type="application/zip"/>
          <glob pattern="*.osk"/>
        </mime-type>
        <mime-type type="application/x-osu-beatmap">
          <comment>osu! beatmap</comment>
          <glob pattern="*.osu"/>
        </mime-type>
        <mime-type type="application/x-osu-storyboard">
          <comment>osu! storyboard</comment>
          <glob pattern="*.osb"/>
        </mime-type>
        <mime-type type="application/x-osu-replay">
          <comment>osu! replay</comment>
          <glob pattern="*.osr"/>
        </mime-type>
      </mime-info>
    '';
  in {
    environment.systemPackages = [
      osu-lazer
      osu-mime
    ];

    home-manager.users."zaroc" = { lib, ... }: {
      xdg.mimeApps.defaultApplications = {
        "application/x-osu-beatmap-archive" = "osu!.desktop";
        "application/x-osu-skin-archive" = "osu!.desktop";
        "application/x-osu-replay" = "osu!.desktop";
        "x-scheme-handler/osu" = "osu!.desktop";
      };

      # the tablet is handled by the OpenTabletDriver daemon (core/input.nix):
      # osu's bundled OTD would fight it over the device, and relative mouse
      # mode ignores the absolute positions coming from OTD's virtual tablet.
      # osu rewrites this file itself, so patch it instead of managing it.
      home.activation.osuInputHandlers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cfg="$HOME/.local/share/osu/input.json"
        if [ -f "$cfg" ]; then
          tmp=$(${pkgs.coreutils}/bin/mktemp)
          ${pkgs.jq}/bin/jq '.InputHandlers |= map(
            if (."$type" | startswith("osu.Framework.Input.Handlers.Tablet.OpenTabletDriverHandler")) then .Enabled = false
            elif (."$type" | startswith("osu.Framework.Input.Handlers.Mouse.MouseHandler")) then .UseRelativeMode = false
            else . end)' "$cfg" > "$tmp" && run mv "$tmp" "$cfg"
        fi
      '';
    };
  };
}
