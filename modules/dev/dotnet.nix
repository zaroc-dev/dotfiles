{ self, ... }: {
  flake = {
    nixosModules.dotnet = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        dotnet-sdk
        nuget
        mono
      ];

      home-manager.users.zaroc.imports = [ self.homeModules.dotnet ];
    };

    homeModules.dotnet = { ... }: {
      home = {
        sessionPath = [ "$HOME/.dotnet/tools" ];

        sessionVariables = {
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
        };
      };
    };
  };
}
