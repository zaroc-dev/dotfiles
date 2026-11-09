{
  lib,
  buildFHSEnv,
  makeDesktopItem,
  symlinkJoin,
  writeShellScript,
  writeShellScriptBin,
}:

let
  environment = buildFHSEnv {
    name = "matlab-env";

    # MATLAB and its installer load bundled binaries at runtime. Keep them in
    # an FHS environment rather than patching a particular MATLAB release.
    targetPkgs =
      pkgs: with pkgs; [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cacert
        cups
        dbus
        expat
        fontconfig
        freetype
        fribidi
        gdk-pixbuf
        glib
        gnumake
        gst_all_1.gst-plugins-base
        gst_all_1.gstreamer
        gtk3
        hidapi
        libcap
        libcap_ng
        libdrm
        libgbm
        libGL
        libglvnd
        libice
        libpsm2
        libsndfile
        libtirpc
        libtool
        libuuid
        libx11
        libxcb
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxfont_2
        libxft
        libxi
        libxinerama
        libxkbcommon
        libxrandr
        libxrender
        libxt
        libxtst
        libxxf86vm
        libxcrypt-legacy
        mosquitto
        net-tools
        nspr
        nss
        numactl
        pam
        pango
        pcre2
        pixman
        procps
        rdma-core
        systemd
        ucx
        unzip
        wayland
        wget
        xdg-utils
        xkeyboard-config
        xkbcomp
        zlib
      ];

    profile = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export LD_LIBRARY_PATH="/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    '';

    runScript = writeShellScript "matlab-dispatch" ''
      set -euo pipefail
      export MATLAB_ROOT="''${MATLAB_ROOT:-$HOME/.local/share/matlab}"

      command="$1"
      shift
      case "$command" in
        run)
          if [[ ! -x "$MATLAB_ROOT/bin/matlab" ]]; then
            printf 'MATLAB was not found at %s.\n' "$MATLAB_ROOT" >&2
            printf 'Run matlab-install /path/to/extracted/installer/install and select that installation folder, or set MATLAB_ROOT.\n' >&2
            exit 1
          fi
          exec "$MATLAB_ROOT/bin/matlab" "$@"
          ;;
        install)
          if [[ $# -eq 0 ]]; then
            printf 'Usage: matlab-install /path/to/extracted/installer/install [installer arguments...]\n' >&2
            exit 1
          fi
          installer="$(realpath -- "$1")"
          shift
          if [[ -d "$installer" ]]; then
            installer="$installer/install"
          fi
          if [[ ! -x "$installer" ]]; then
            printf 'MATLAB installer is not executable: %s\n' "$installer" >&2
            exit 1
          fi
          printf 'Select %s as the installation folder in the MathWorks installer.\n' "$MATLAB_ROOT"
          cd -- "$(dirname -- "$installer")"
          exec "$installer" "$@"
          ;;
        shell)
          exec /bin/bash "$@"
          ;;
      esac
    '';
  };
in
symlinkJoin {
  name = "matlab";

  paths = [
    (writeShellScriptBin "matlab" ''
      exec ${lib.getExe environment} run "$@"
    '')
    (writeShellScriptBin "matlab-install" ''
      exec ${lib.getExe environment} install "$@"
    '')
    (writeShellScriptBin "matlab-shell" ''
      exec ${lib.getExe environment} shell "$@"
    '')
    (makeDesktopItem {
      name = "matlab";
      desktopName = "MATLAB";
      comment = "Scientific computing environment";
      exec = "matlab -desktop %F";
      icon = "applications-science";
      categories = [
        "Development"
        "Science"
        "Math"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "FHS wrapper and installer environment for a licensed MATLAB installation";
    homepage = "https://www.mathworks.com/products/matlab.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "matlab";
  };
}
