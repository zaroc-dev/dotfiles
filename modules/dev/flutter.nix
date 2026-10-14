{ ... }: {
  flake.nixosModules.flutter =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          flutter
          cmake
          clang
          ninja
          pkg-config
          mesa-demos
        ];

        # gradle needs a JDK for android builds; nothing else provides one
        variables.JAVA_HOME = pkgs.jdk17.home;
      };
    };
}
