{ inputs, ... }:
{
  flake.homeModules.rinka =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.rinka.homeManagerModules.default ];

      services.rinka.enable = true;

      # Yuki watches this writable file in both the checkout and packaged shell.
      # Keep its other preferences, lock backgrounds and color sources intact.
      home.activation.rinkaWallpaper = lib.mkIf config.programs.yuki.enable (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ${pkgs.python3}/bin/python3 - ${lib.escapeShellArg "${config.xdg.stateHome}/quickshell/by-shell/yuki/settings.json"} <<'PY'
          import json
          import os
          import sys
          import tempfile
          from pathlib import Path

          path = Path(sys.argv[1])
          settings = json.loads(path.read_text()) if path.exists() else {}
          settings["wallpaperEnabled"] = False
          path.parent.mkdir(parents=True, exist_ok=True)
          fd, temporary = tempfile.mkstemp(dir=path.parent)
          try:
              with os.fdopen(fd, "w") as output:
                  json.dump(settings, output, indent=4)
                  output.write("\n")
              os.replace(temporary, path)
          finally:
              if os.path.exists(temporary):
                  os.unlink(temporary)
          PY
        ''
      );
    };
}
