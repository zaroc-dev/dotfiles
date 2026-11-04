{ ... }:
{
  flake.nixosModules.cli-tools =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
        codex
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
