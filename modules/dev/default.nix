{ self, ... }: {
  flake.nixosModules.development = { pkgs, ... }: {
    imports = [
      self.nixosModules.android
      self.nixosModules.cli-tools
      self.nixosModules.javascript
      self.nixosModules.python
      self.nixosModules.dotnet
      self.nixosModules.java
      self.nixosModules.git
    ];

    environment.systemPackages = with pkgs; [
      zed-editor
      nil
      nixfmt
      nixd
      gcc
    ];
  };
}
