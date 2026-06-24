{ self, ... }: {
  flake.homeModules.git = { ... }: {
    home.file.".config/git/commit.template" = {
      source = self + /.config/git/commit.template;
    };
    home.file.".config/git/allowed_signers" = {
      source = self + /.config/git/allowed_signers;
    };
  };

  flake.nixosModules.git = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.gh ];

    programs.git = {
      enable = true;

      config = {
        init.defaultBranch = "main";
        pull.rebase = true;

        user = {
          name = "ruzbyte";
          email = "arthuraktamirov@gmail.com";
          signingKey = "~/.ssh/github.pub";
        };

        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";

        commit = {
          gpgsign = true;
          template = "~/.config/git/commit.template";
        };

        tag.gpgsign = true;
      };
    };
  };
}
