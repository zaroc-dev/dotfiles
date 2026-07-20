{ self, ... }: {
  flake.nixosModules.development = { ... }: {
    imports = [
      self.nixosModules.android
      self.nixosModules.flutter
      self.nixosModules.cli-tools
      self.nixosModules.javascript
      self.nixosModules.python
      self.nixosModules.dotnet
      self.nixosModules.java
      self.nixosModules.git
      self.nixosModules.docker
      self.nixosModules.ides
      self.nixosModules.rust
    ];
  };
}
