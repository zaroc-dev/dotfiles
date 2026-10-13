{ self, config, ... }: {
  flake = {
    nixosModules.git = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.gh ];

      programs.git = {
        enable = true;

        config = {
          init.defaultBranch = "main";
          pull.rebase = true;

          user = {
            inherit (config.git) name email;
            signingKey = "~/.ssh/github.pub";
          };

          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = "~/.config/git/allowed_signers";
          };

          commit = {
            gpgsign = true;
            template = "~/.config/git/commit.template";
          };

          tag.gpgsign = true;
        };
      };

      home-manager.users.${config.username}.imports = [ self.homeModules.git ];
    };

    homeModules.git = { ... }: {
      home.file = {
        ".config/git/commit.template".source = self + /.config/git/commit.template;
        ".config/git/allowed_signers".source = self + /.config/git/allowed_signers;
      };
    };
  };
}
