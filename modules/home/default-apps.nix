{ ... }: {
  flake.homeModules.defaultApps = { ... }: {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "application/pdf" = "zen.desktop";
        "inode/directory" = "yazi.desktop";
        "text/plain" = "dev.zed.Zed.desktop";
      };
    };

    # desktop-specific overrides: consulted before mimeapps.list when
    # XDG_CURRENT_DESKTOP matches the file's prefix
    xdg.configFile."niri-mimeapps.list".text = ''
      [Default Applications]
      inode/directory=org.kde.dolphin.desktop
    '';
  };
}
