{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libdrm,
  libGL,
  libglvnd,
  libnotify,
  libpulseaudio,
  libusb1,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  qt5,
  qt6,
  systemd,
  vulkan-loader,
  xdg-utils,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxshmfence,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chatgpt-desktop";
  version = "26.903.61454";

  src = fetchurl {
    # OpenAI currently exposes the RPM through a mutable `latest` URL. The
    # fixed hash keeps this derivation reproducible and makes updates explicit.
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/rpm/latest/chatgpt.x86_64.rpm";
    hash = "sha256-QvWilN+o4C0QJmEzl4qCy8aGJpeutgnCqJCXT5YW7LI=";
  };

  nativeBuildInputs = [
    rpmextract
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libglvnd
    libnotify
    libpulseaudio
    libusb1
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    vulkan-loader
    stdenv.cc.cc.lib
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxshmfence
  ];

  # The RPM bundles both glibc and musl Node prebuilds. NixOS uses the glibc
  # variants; the musl siblings are selected only on musl systems.
  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  unpackPhase = ''
    runHook preUnpack
    rpmextract "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib" "$out/share"
    cp -r usr/lib/chatgpt "$out/lib/"
    cp -r usr/share/applications "$out/share/"
    cp -r usr/share/pixmaps "$out/share/"
    rm -f "$out/lib/chatgpt/chrome-sandbox"
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/lib/chatgpt/ChatGPT" "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libglvnd
          libGL
          mesa
          vulkan-loader
          qt5.qtbase
          qt6.qtbase
        ]
      } \
      --add-flags "--ozone-platform-hint=auto --password-store=gnome-libsecret"

    substituteInPlace "$out/share/applications/chatgpt.desktop" \
      --replace-fail "Exec=chatgpt" "Exec=$out/bin/chatgpt"
  '';

  meta = {
    description = "Official ChatGPT desktop app for Linux";
    homepage = "https://chatgpt.com/download";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chatgpt";
  };
})
