{ ... }: {
  flake.homeModules.vscode = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;

      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        # Merge these values on activation while keeping Settings Sync and UI
        # edits usable. Declared values win on the next rebuild.
        mutableUserSettings = true;
        userSettings = {
          "git.confirmSync" = false;
          "workbench.colorTheme" = "Aura Dark";
          "docker.extension.enableComposeLanguageServer" = false;
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" = false;
          "workbench.startupEditor" = "none";
          "workbench.sideBar.location" = "right";
          "workbench.iconTheme" = "material-icon-theme";
          "explorer.confirmPasteNative" = false;
          "vsicons.dontShowNewVersionMessage" = true;
          "markdown-pdf.executablePath" = "${pkgs.google-chrome}/bin/google-chrome-stable";
        };

        extensions = (with pkgs.vscode-extensions; [
          bbenoist.nix
          bradlc.vscode-tailwindcss
          charliermarsh.ruff
          dart-code.dart-code
          dart-code.flutter
          dbaeumer.vscode-eslint
          docker.docker
          dotjoshjohnson.xml
          ecmel.vscode-html-css
          enkia.tokyo-night
          esbenp.prettier-vscode
          formulahendry.auto-rename-tag
          ms-vscode.makefile-tools
          ms-vscode.powershell
          ms-vscode.remote-explorer
          ms-vscode.test-adapter-converter
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode-remote.remote-wsl
          ms-vscode-remote.vscode-remote-extensionpack
          pkief.material-icon-theme
          redhat.vscode-xml
          redhat.vscode-yaml
          ritwickdey.liveserver
          rust-lang.rust-analyzer
          svelte.svelte-vscode
          tomoki1207.pdf
          unifiedjs.vscode-mdx
          vitest.explorer
          vscode-icons-team.vscode-icons
          yzane.markdown-pdf
        ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          # Extensions absent from the pinned Nixpkgs, at their synced versions.
          {
            publisher = "chrisdias";
            name = "vscode-opennewinstance";
            version = "0.0.15";
            hash = "sha256-NH5e8hHhQWGJFAS6lNSfnrZJle4N0kM7gD7MTZgtJKs=";
          }
          {
            publisher = "daltonmenezes";
            name = "aura-theme";
            version = "2.1.2";
            hash = "sha256-r6pPpvJ1AZsM0RYF+xHsZ4b4QTszN+wELr1SENsUDFA=";
          }
          {
            publisher = "dustypomerleau";
            name = "rust-syntax";
            version = "0.6.1";
            hash = "sha256-o9iXPhwkimxoJc1dLdaJ8nByLIaJSpGX/nKELC26jGU=";
          }
          {
            publisher = "eternal";
            name = "tokyo-night-horizon";
            version = "1.0.7";
            hash = "sha256-oJ4JhwLS86eSilJ8WJJPeJABxzw+M5JNuboxoL4cnB8=";
          }
          {
            publisher = "ms-vscode";
            name = "remote-server";
            version = "1.5.3";
            hash = "sha256-MSayIBwvSgIHg6gTrtUotHznvo5kTiveN8iSrehllW0=";
          }
        ];
      };
    };
  };
}
