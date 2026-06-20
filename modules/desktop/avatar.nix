{ self, ... }: {
  flake.nixosModules.avatar =
    { ... }:
    let
      avatar = self + /icons/lilith_monochrome_clean.png;
    in
    {
      system.activationScripts.userAvatar = ''
        mkdir -p /var/lib/AccountsService/icons /var/lib/AccountsService/users
        install -m 0644 ${avatar} /var/lib/AccountsService/icons/ruzbyte
        printf '[User]\nIcon=/var/lib/AccountsService/icons/ruzbyte\n' \
                  > /var/lib/AccountsService/users/ruzbyte
      '';
    };
}
