{ ... }: {
  flake.nixosModules.android = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.android-tools
      pkgs.android-studio
    ];

    programs.nix-ld.enable = true;
    # The Android SDK's prebuilt tools (adb, aapt2, the emulator + its bundled
    # qemu, …) that Android Studio downloads into ~/Android/Sdk are
    # generic-Linux ELFs; nix-ld provides the loader + libraries so they run.
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      zlib

      glib
      nss
      nspr
      expat
      dbus
      fontconfig
      freetype
      alsa-lib
      libpulseaudio
      libGL
      libdrm
      libxkbcommon
      libX11
      libXext
      libXcursor
      libXrandr
      libXi
      libXcomposite
      libXdamage
      libxfixes
      libxrender
      libxtst
      libxcb
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
