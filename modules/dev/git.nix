{ self, ... }: {
  flake.homeModules.git = { ... }: {
    home.file.".config/git/commit.template" = {
      source = self + /.config/git/commit.template;
    };
  };

  flake.nixosModules.git = { ... }: {
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

        commit = {
          gpgsing = true;
          template = "~/.config/git/commit.template";
        };

        tag.gpgsign = true;
      };
    };
  };
}
