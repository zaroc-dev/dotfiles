{ self, config, ... }: {
  flake = {
    nixosModules.android = { pkgs, ... }: {
      # adb/fastboot; device access is handled by systemd uaccess rules,
      # so the old programs.adb / adbusers group is no longer needed.
      environment.systemPackages = with pkgs; [
        android-studio
      ];

      # emulator hardware acceleration
      users.users.${config.username}.extraGroups = [ "kvm" ];

      home-manager.users.${config.username}.imports = [ self.homeModules.android ];
    };

    # SDK is managed by Android Studio's SDK Manager in ~/Android/Sdk
    homeModules.android =
      { config, ... }:
      let
        sdk = "${config.home.homeDirectory}/Android/Sdk";
      in
      {
        home = {
          sessionVariables = {
            ANDROID_HOME = sdk;
            # Swing apps render blank windows on non-reparenting WMs (niri)
            _JAVA_AWT_WM_NONREPARENTING = "1";
          };

          sessionPath = [
            "${sdk}/platform-tools"
            "${sdk}/emulator"
            "${sdk}/cmdline-tools/latest/bin"
          ];
        };
      };
  };
}
