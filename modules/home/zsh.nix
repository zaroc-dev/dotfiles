{ ... }: {
  # Nix-managed zsh (kept out of the dotfiles so NixOS hosts can carry their
  # own aliases). Hostname is read from the system config via osConfig, so new
  # hosts work without touching flake.nix.
  flake.homeModules.zsh = { pkgs, osConfig, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion          = true;
      autosuggestion.enable     = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ls   = "eza --icons --group-directories-first";
        ll   = "eza -l --icons --group-directories-first";
        la   = "eza -a --icons";
        lah  = "eza -lah --icons";
        lla  = "eza -la --icons";
        tree = "eza --tree --icons";

        gs   = "git status";
        ga   = "git add";
        gc   = "git commit";
        gp   = "git push";
        gl   = "git log";
        gd   = "git diff";
        gco  = "git checkout";
        gb   = "git branch";
        gcb  = "git checkout -b";
        gcm  = "git commit -m";
        gpl  = "git pull";
        gst  = "git stash";
        gsta = "git stash apply";
        gstd = "git stash drop";
        gss  = "git stash show -p";

        dc   = "docker compose";
        dcb  = "docker compose build";
        dcu  = "docker compose up";
        dcd  = "docker compose down";
        dl   = "docker logs -f";
        dps  = "docker ps";

        nrs  = "sudo nixos-rebuild switch --flake ~/dotfiles#${osConfig.networking.hostName}";
        nrt  = "sudo nixos-rebuild test   --flake ~/dotfiles#${osConfig.networking.hostName}";
        nrsu = "sudo nixos-rebuild switch --flake ~/dotfiles#${osConfig.networking.hostName} --upgrade";
        nfu  = "nix flake update ~/dotfiles";
        nsh  = "nix shell";
        ngc  = "sudo nix-collect-garbage -d --delete-older-than 7d";
        ngca = "sudo nix-collect-garbage -d";

        vim  = "nvim";
        cat  = "bat";
        cd   = "z";
        cdi  = "zi";
        zsrc = "source ~/.zshrc";
      };

      initContent = ''
        setopt AUTO_CD
        setopt CORRECT
        HISTSIZE=10000
        SAVEHIST=10000
        HISTFILE=~/.zsh_history

        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-z1-2}={A-Z1-2}'

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        fastfetch
      '';
    };

    # Tools backing the aliases above (cat -> bat, cd -> z).
    programs.bat.enable = true;
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
