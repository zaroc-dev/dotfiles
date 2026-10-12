{ self, ... }: {
  flake.nixosModules.development = { pkgs, ... }: {
    imports = [
      # self.nixosModules.flutter
      self.nixosModules.android
      self.nixosModules.cli-tools
      self.nixosModules.javascript
      self.nixosModules.python
      # self.nixosModules.dotnet
      # self.nixosModules.java
      self.nixosModules.git
      self.nixosModules.docker
      self.nixosModules.rust
    ];

    home-manager.users.zaroc.imports = [ self.homeModules.vscode ];

    environment.systemPackages = with pkgs; [
      zed-editor
      google-chrome
    ];
  };
}
