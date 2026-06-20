{ ... }: {
  flake.nixosModules.ssh = { ... }: {
    programs.ssh = {
      extraConfig = "
        Host github.com
          HostName github.com
          User git
          IdentityFile = ~/.ssh/github
      ";
    };
  };
}
