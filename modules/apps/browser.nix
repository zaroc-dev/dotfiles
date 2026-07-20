{ inputs, ... }: {
  flake.homeModules.zenBrowser = { pkgs, ... }:
    let
      extension = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";

      policies = {
          DisableAppUpdate = true;
          DisplayBookmarksToolbar = true;

          Preferences = {
            "browser.toolbars.bookmarks.visibility" = {
              Value = "always";
              Status = "locked";
            };
            "zen.view.compact.enable-at-startup" = {
              Value = false;
              Status = "locked";
            };
            "zen.view.use-single-toolbar" = {
              Value = false;
              Status = "locked";
            };
          };

          Bookmarks = [
            {
              Title = "GitHub";
              URL = "https://github.com/";
              Placement = "toolbar";
            }
            {
              Title = "YouTube";
              URL = "https://www.youtube.com/";
              Placement = "toolbar";
            }
            {
              Title = "WhatsApp";
              URL = "https://web.whatsapp.com/";
              Placement = "toolbar";
            }
            {
              Title = "Google Calendar";
              URL = "https://calendar.google.com/";
              Placement = "toolbar";
            }
          ];

          Extensions.Install = map extension [
            "bitwarden-password-manager"
            "ublock-origin"
            "material-icons-for-github"
            "volumecontrol"
          ];
      };

      zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        wrapFirefox = unwrapped: options:
          pkgs.wrapFirefox unwrapped (options // { extraPolicies = policies; });
      };
    in
    {
      home.packages = [ zen ];
    };
}
