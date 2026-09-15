{ self, ... }: {
  flake.nixosModules.brave = { pkgs, ... }:
    let
      policies = {
        BookmarkBarEnabled = true;

        ManagedBookmarks = [
          { name = "GitHub"; url = "https://github.com/"; }
          { name = "YouTube"; url = "https://www.youtube.com/"; }
          { name = "WhatsApp"; url = "https://web.whatsapp.com/"; }
          { name = "Google Calendar"; url = "https://calendar.google.com/"; }
        ];

        ExtensionSettings = {
          # Bitwarden. Installed automatically, but can still be disabled.
          "nngceckbapebfimnlniiiahkandclblb" = {
            installation_mode = "normal_installed";
            update_url = "https://clients2.google.com/service/update2/crx";
          };
        };

        BraveRewardsDisabled = true;
        BraveWalletDisabled = true;
        BraveVPNDisabled = true;
        BraveNewsDisabled = true;
        BraveAIChatEnabled = false;

        # Keep Safe Browsing and Brave's default Shields protection.
        # Shields handles ad blocking without a separate uBlock extension.
        SafeBrowsingProtectionLevel = 1;
      };
    in
    {
      environment.systemPackages = [ pkgs.brave ];

      environment.etc."brave/policies/managed/policies.json".text =
        builtins.toJSON policies;
    };

  flake.homeModules.brave = { config, lib, pkgs, ... }:
    let
      # Selected preferences from Brave's UI. Seed fresh profiles only; Brave
      # keeps the files writable and subsequent UI changes survive rebuilds.
      preferences = {
        browser = {
          custom_chrome_frame = false;
          pin_split_tab_button = true;
          show_home_button = true;
          theme = {
            color_variant2 = 1;
            user_color2 = -16761601;
          };
        };

        brave = {
          darker_mode = false;
          enable_media_router_on_restart = true;
          has_seen_brave_welcome_page = true;
          location_bar_is_wide = true;
          web_view_rounded_corners = false;

          new_tab_page = {
            background = {
              random = false;
              selected_value = "Vera_Garnet.png";
              type = "custom_image";
            };
            custom_background_image_list = [ "Vera_Garnet.png" ];
            clock_format = "h24";
            show_together = false;
          };

          sidebar = {
            sidebar_show_option = 3; # Never show the sidebar.
            hidden_built_in_items = [ ];
            sidebar_items = [
              { built_in_item_type = 1; type = 0; }
              { built_in_item_type = 3; type = 0; }
              { built_in_item_type = 4; type = 0; }
              {
                built_in_item_type = 0;
                type = 1;
                open_in_panel = false;
                title = "Settings";
                url = "chrome://settings/";
              }
            ];
          };

          tabs = {
            always_hide_tab_close_button = false;
            scrollable_horizontal_tab_strip = true;
          };

          default_private_search_provider_data = googleSearch;
        };

        default_search_provider_data.template_url_data = googleSearch;
        intl.selected_languages = "en-US,en";
        spellcheck.dictionaries = [ "en-US" ];
        tab_search.pinned_to_tabstrip = true;
        toolbar.pinned_actions = [
          "kActionShowChromeLabs"
          "kActionShowDownloads"
          "kActionDevTools"
          "kActionCopyUrl"
        ];
      };

      googleSearch = {
        short_name = "Google";
        keyword = ":g";
        url = "https://www.google.com/search?q={searchTerms}";
        suggestions_url = "https://www.google.com/complete/search?client=chrome&q={searchTerms}";
        favicon_url = "https://www.google.com/favicon.ico";
        input_encodings = [ "UTF-8" ];
        prepopulate_id = 1;
        safe_for_autoreplace = true;
      };

      profileSeed = pkgs.writeText "brave-preferences.json" (builtins.toJSON preferences);
      localStateSeed = pkgs.writeText "brave-local-state.json" (builtins.toJSON {
        brave.tabs.compact_horizontal_tabs = false;
      });
      browserDir = "${config.xdg.configHome}/BraveSoftware/Brave-Browser";
      wallpaper = self + /wallpapers/Vera_Garnet.png;
    in
    {
      home.activation.braveDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Never replace an existing profile or edit preferences during a session.
        if [ ! -L ${lib.escapeShellArg "${browserDir}/SingletonLock"} ]; then
          if [ ! -e ${lib.escapeShellArg "${browserDir}/Default/Preferences"} ]; then
            run ${pkgs.coreutils}/bin/install -Dm600 ${profileSeed} \
              ${lib.escapeShellArg "${browserDir}/Default/Preferences"}
          fi
          if [ ! -e ${lib.escapeShellArg "${browserDir}/Local State"} ]; then
            run ${pkgs.coreutils}/bin/install -Dm600 ${localStateSeed} \
              ${lib.escapeShellArg "${browserDir}/Local State"}
          fi
        fi
        if [ ! -e ${lib.escapeShellArg "${browserDir}/Default/sanitized_background_images/Vera_Garnet.png"} ]; then
          run ${pkgs.coreutils}/bin/install -Dm600 ${wallpaper} \
            ${lib.escapeShellArg "${browserDir}/Default/sanitized_background_images/Vera_Garnet.png"}
        fi
      '';
    };
}
