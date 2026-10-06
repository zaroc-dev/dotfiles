{ self, ... }: {
  flake.nixosModules.avatar =
    { ... }:
    let
      avatar = self + /icons/lilith_monochrome_clean.png;
    in
    {
      services.accounts-daemon.enable = true;

      system.activationScripts.userAvatar = ''
        mkdir -p /var/lib/AccountsService/icons /var/lib/AccountsService/users
        install -m 0644 ${avatar} /var/lib/AccountsService/icons/zaroc
        printf '[User]\nIcon=/var/lib/AccountsService/icons/zaroc\n' \
                  > /var/lib/AccountsService/users/zaroc
      '';
    };
}
