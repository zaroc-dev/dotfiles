{ ... }: {
  flake.nixosModules.ai = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      claude-code
      codex
      t3code
      opencode
    ];

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
    };

    services.open-webui = {
      enable = true;
    };
  };
}
