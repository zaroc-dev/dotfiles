{ ... }: {
  flake.nixosModules.android = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.android-tools
      pkgs.android-studio
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.android-fhs = pkgs.buildFHSEnv {
      name = "android-gradle-fhs";
      targetPkgs =
        p: with p; [
          jdk17
          stdenv.cc.cc.lib
          zlib
          libGL
          freetype
          fontconfig
          which
        ];

      profile = ''
        export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
        export ANDROID_HOME="$ANDROID_SDK_ROOT"
        export JAVA_HOME="${pkgs.jdk17.home}"
        export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
      '';
      runScript = "bash";
    };
  };
}
