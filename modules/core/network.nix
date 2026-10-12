{ ... }:
{
  flake.nixosModules.network =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bind
      ];
      # SECTION mDNS
      # resolved already resolves .local (mDNS enabled via NetworkManager),
      # but the firewall drops the multicast responses without this
      networking.firewall.allowedUDPPorts = [ 5353 ];
      # !SECTION

      # Opens port 22 in the firewall by default (services.openssh.openFirewall).
      services.openssh.enable = true;
    };
}
