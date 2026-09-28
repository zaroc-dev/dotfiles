{ self, ... }: {
  flake.nixosModules.chat = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt-desktop
      self.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
      pkgs.teams-for-linux
      (pkgs.discord.override { withVencord = true; })
    ];

    # Claude's downloaded Code runtime expects a conventional dynamic loader.
    programs.nix-ld.enable = true;

    # Cowork's microVM currently uses Debian-style absolute paths.
    systemd.tmpfiles.rules = [
      "L+ /usr/share/OVMF/OVMF_CODE.fd    - - - - ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd"
      "L+ /usr/share/OVMF/OVMF_CODE_4M.fd - - - - ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd"
      "L+ /usr/share/OVMF/OVMF_VARS.fd    - - - - ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd"
      "L+ /usr/share/OVMF/OVMF_VARS_4M.fd - - - - ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd"
      "L+ /usr/libexec/virtiofsd          - - - - ${pkgs.virtiofsd}/bin/virtiofsd"
    ];
  };
}
