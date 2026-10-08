{ ... }:
{
  flake.nixosModules.network =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bind
      ];
      networking.firewall = {
        allowedTCPPorts = [ 22 ];

        # SECTION mDNS
        # resolved already resolves .local (mDNS enabled via NetworkManager),
        # but the firewall drops the multicast responses without this
        allowedUDPPorts = [ 5353 ];
        # !SECTION
      };

      services.openssh.enable = true;
    };
}
