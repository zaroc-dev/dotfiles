{ lib, ... }:
{
  # Shared across modules via the outer flake-parts `config`. Inner NixOS/HM
  # modules shadow `config`, so bind it in a `let` when they also take one.
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "zaroc";
      description = "Primary user account on every host.";
    };

    git = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "zaroc";
        description = "Git author name.";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = "arthuraktamirov@gmail.com";
        description = "Git author email.";
      };
    };
  };
}
