{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "ye-shunguang-cursors";
  version = "1.0";

  src = ../icons/cursors/ye-shunguang-zzz-cursors.tar.xz;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/icons/ye-shunguang-zzz-cursors"
    cp -a cursors index.theme "$out/share/icons/ye-shunguang-zzz-cursors/"
    runHook postInstall
  '';

  meta = {
    description = "Ye Shunguang ZZZ cursor theme";
    homepage = "https://www.gnome-look.org/p/2370526";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
