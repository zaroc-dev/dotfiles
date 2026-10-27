{
  lib,
  stdenv,
  fetchurl,
  dpkg,
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
  glib,
  gtk3,
  libgbm,
  libglvnd,
  libsecret,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  codex,
  gh,
  git,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "t3code-nightly";
  version = "0.1.4-nightly.20261027.3770";

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${finalAttrs.version}/T3-Code-${finalAttrs.version}-amd64.deb";
    hash = "sha256-WWQiys/zom91cP13IWmVe82t5ro6y0qykooNqlW2cf8=";
  };

  nativeBuildInputs = [
    dpkg
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
    glib
    gtk3
    libgbm
    libsecret
    libxkbcommon
    nspr
    nss
    pango
    systemd
    stdenv.cc.cc.lib
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile "$src" | tar -x --no-same-owner --no-same-permissions
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib" "$out/share"
    cp -r "opt/T3 Code (Nightly)" "$out/lib/t3code"
    cp -r usr/share/applications usr/share/icons "$out/share/"
    rm -f "$out/lib/t3code/chrome-sandbox"

    # NixOS uses the x64 glibc modules; omit foreign and musl binaries before fixup.
    modules="$out/lib/t3code/resources/app.asar.unpacked/node_modules"
    rm -rf "$modules/node-pty/prebuilds/linux-arm64" \
      "$modules/@ff-labs/fff-bin-linux-x64-musl" \
      "$modules/@yuuang/ffi-rs-linux-x64-musl"
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/lib/t3code/t3code" "$out/bin/t3code-desktop" \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${
        lib.makeBinPath [
          codex
          gh
          git
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libglvnd
          vulkan-loader
        ]
      }

    substituteInPlace "$out/share/applications/t3code.desktop" \
      --replace-fail 'Exec="/opt/T3 Code (Nightly)/t3code"' "Exec=$out/bin/t3code-desktop"
  '';

  meta = {
    description = "Nightly build of the T3 Code desktop app for coding agents";
    homepage = "https://t3.codes";
    downloadPage = "https://github.com/pingdotgg/t3code/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "t3code-desktop";
  };
})
