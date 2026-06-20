{ self, ... }: {
  flake.homeModules.starship = { ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # Single source of truth: read the prompt config straight from dotfiles.
      settings = builtins.fromTOML (builtins.readFile "${self}/.config/starship.toml");
    };
  };
}
