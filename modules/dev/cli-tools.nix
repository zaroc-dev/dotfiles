{ ... }: {
  flake.nixosModules.cli-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      claude-code
      codex
    ];
  };
}
