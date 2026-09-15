{ self, ... }: {
  flake.nixosModules.development = { pkgs, ... }: {
    imports = [
      # self.nixosModules.flutter
      self.nixosModules.cli-tools
      self.nixosModules.javascript
      self.nixosModules.python
      # self.nixosModules.dotnet
      # self.nixosModules.java
      self.nixosModules.git
      self.nixosModules.docker
      self.nixosModules.rust
    ];

    environment.systemPackages = with pkgs; [
      zed-editor
      google-chrome
    ];
  };
}
