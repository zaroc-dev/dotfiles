{ ... }: {
  flake.nixosModules.flutter =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        flutter
        cmake
        clang
        ninja
        pkg-config
        mesa-demos
        google-chrome
      ];
    };
}
