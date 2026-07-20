{ ... }: {
  flake.nixosModules.cli-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      claude-code
      codex
      t3code
      opencode
      nil
      nixfmt
      nixd
      prettier
      stylua
      lazygit
      tree-sitter
      gcc
    ];
  };
}
