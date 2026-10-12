{ self, ... }: {
  flake.homeModules.starship =
    { lib, osConfig, ... }:
    let
      # Each host gets its own colored pill, so it's obvious which machine a
      # shell is on. Colors are ANSI names (see .config/starship.toml).
      hosts = {
        hiyuki = {
          color = "purple";
          icon = "󰍹";
        };
        acheron = {
          color = "yellow";
          icon = "󰌢";
        };
        miyabi = {
          color = "cyan";
          icon = "󰖳";
        };
      };
      host =
        hosts.${osConfig.networking.hostName} or {
          color = "white";
          icon = "󰒋";
        };
    in
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings =
          lib.recursiveUpdate (builtins.fromTOML (builtins.readFile "${self}/.config/starship.toml"))
            {
              hostname.format = "[](fg:${host.color})[ ${host.icon} $hostname$ssh_symbol ](bold fg:black bg:${host.color})[](fg:${host.color}) ";
            };
      };
    };
}
