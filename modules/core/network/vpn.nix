{ ... }:
{
  flake.nixosModules.vpn =
    { pkgs, ... }:
    {
      networking.networkmanager = {
        plugins = [ pkgs.networkmanager-openconnect ];
        ensureProfiles.profiles.hs-albsig = {
          connection = {
            id = "Hochschule Albstadt-Sigmaringen";
            uuid = "bec7e85b-551c-4c65-99fb-e41a3d076cd3";
            type = "vpn";
            autoconnect = false;
          };
          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            gateway = "vpn.hs-albsig.de";
            protocol = "anyconnect";
            cookie-flags = 2;
            gateway-flags = 2;
            gwcert-flags = 2;
            resolve-flags = 2;
          };
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };

      environment.systemPackages = [
        # Also available to the live shell checkout before its package is updated.
        pkgs.openconnect
        (pkgs.writeShellApplication {
          name = "hs-albsig-vpn";
          text = ''
            case "''${1:-connect}" in
              connect|up)
                yuki ipc call vpn on "Hochschule Albstadt-Sigmaringen"
                ;;
              disconnect|down|cancel)
                yuki ipc call vpn off "Hochschule Albstadt-Sigmaringen"
                ;;
              status)
                yuki ipc call vpn status
                ;;
              *)
                echo "Usage: hs-albsig-vpn [connect|disconnect|status]" >&2
                exit 2
                ;;
            esac
          '';
        })
      ];

      services.mullvad-vpn = {
        enable = true;
        gui.enable = true;
      };
    };
}
