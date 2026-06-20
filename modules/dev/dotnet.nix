{ ... }: {
  flake.nixosModules.dotnet = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      dotnet-sdk
      nuget
      mono
      jetbrains.rider
    ];
  };

  flake.homeModules.dotnet = { ... }: {
    home.sessionPath = [
      "$HOME/.dotnet/tools"
    ];

    home.sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
    };
  };
}
