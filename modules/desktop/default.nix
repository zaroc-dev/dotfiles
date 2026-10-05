{ self, ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    imports = [
      self.nixosModules.niri
      self.nixosModules.avatar
    ];

    environment.systemPackages = with pkgs; [
      ffmpeg
      poppler # pdf
      resvg # svg
      imagemagick # imgs HEIC/JPEG
    ];
  };
}
