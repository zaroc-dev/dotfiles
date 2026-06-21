{ self, ... }: {
  flake.homeModules.starship = { ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (builtins.readFile "${self}/.config/starship.toml");
    };
  };
}
