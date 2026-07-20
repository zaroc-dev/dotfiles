{ ... }: {
  flake.nixosModules.rust = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      rustup
      unzip
    ];
  };

  flake.homeModules.rust = { ... }: {
    home.sessionPath = [ "$HOME/.cargo/bin" ];

    home.sessionVariables = {
      CARGO_HOME = "$HOME/.cargo";
      RUSTUP_HOME = "$HOME/.rustup";
    };

    programs.zsh.shellAliases = {
      cb = "cargo build";
      cr = "cargo run";
      ct = "cargo test";
      cw = "cargo watch -x run";
      cla = "cargo clippy -- -D warnings";
    };
  };
}
