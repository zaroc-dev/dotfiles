{ self, ... }:
{
  flake.homeModules.webapps =
    { pkgs, ... }:
    let
      mkWebapp = id: name: url: {
        inherit name;
        exec = "${pkgs.brave}/bin/brave --app=${url}";
        icon = "${self}/icons/apps/${id}.png";
        categories = [ "Network" ];
        terminal = false;
      };
    in
    {
      xdg.desktopEntries = {
        youtube = mkWebapp "youtube" "YouTube" "https://www.youtube.com/";
        twitch = mkWebapp "twitch" "Twitch" "https://www.twitch.tv/";
        github = mkWebapp "github" "GitHub" "https://github.com/";
        google-calendar = mkWebapp "google-calendar" "Google Calendar" "https://calendar.google.com/";
      };
    };
}
