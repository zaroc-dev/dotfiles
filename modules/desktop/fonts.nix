{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
    ];
  };
}
