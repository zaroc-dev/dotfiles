{ self, config, ... }:
let
  # Chromium picks its cookie key store per desktop (KWallet on Plasma,
  # gnome-keyring on niri), and each holds a different key. Pin one so sessions
  # survive switching desktops.
  packageFor = pkgs: pkgs.brave.override { commandLineArgs = "--password-store=gnome-libsecret"; };
in
{
  flake = {
    nixosModules.brave =
      { pkgs, ... }:
      let
        policies = {
          BookmarkBarEnabled = true;

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
        environment = {
          systemPackages = [ (packageFor pkgs) ];
          etc."brave/policies/managed/policies.json".text = builtins.toJSON policies;
        };

        home-manager.users.${config.username}.imports = [ self.homeModules.brave ];
      };

    homeModules.brave =
      {
        config,
        lib,
        pkgs,
        ...
      }:
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
            brave_search.show-ntp-search = false;
            darker_mode = false;
            enable_media_router_on_restart = true;
            has_seen_brave_welcome_page = true;
            location_bar_is_wide = true;
            web_view_rounded_corners = false;

            new_tab_page = {
              background = {
                random = false;
                selected_value = wallpaperName;
                type = "custom_image";
              };
              custom_background_image_list = [ wallpaperName ];
              clock_format = "h24";
              show_clock = true;
              show_together = false;
            };

            sidebar = {
              sidebar_show_option = 3; # Never show the sidebar.
              hidden_built_in_items = [ ];
              sidebar_items = [
                {
                  built_in_item_type = 1;
                  type = 0;
                }
                {
                  built_in_item_type = 3;
                  type = 0;
                }
                {
                  built_in_item_type = 4;
                  type = 0;
                }
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
          ntp.shortcust_visible = false; # Brave's preference name contains this typo.
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
        localStateSeed = pkgs.writeText "brave-local-state.json" (
          builtins.toJSON {
            brave.tabs.compact_horizontal_tabs = false;
          }
        );
        # ManagedBookmarks always adds a folder. Merge these regular bar
        # bookmarks into existing profiles, preserving personal bookmarks.
        bookmarks = [
          {
            name = "GitHub";
            url = "https://github.com/";
          }
          {
            name = "GitLab";
            url = "https://gitlab.com/";
          }
          {
            name = "OneDrive";
            url = "https://onedrive.live.com/";
          }
          {
            name = "Teams";
            url = "https://teams.cloud.microsoft/";
          }
          {
            name = "Google Drive";
            url = "https://drive.google.com/";
          }
          {
            name = "Gmail";
            url = "https://gmail.com/";
          }
          {
            name = "YouTube";
            url = "https://www.youtube.com/";
          }
          {
            name = "WhatsApp";
            url = "https://web.whatsapp.com/";
          }
          {
            name = "Google Calendar";
            url = "https://calendar.google.com/";
          }
          {
            name = "Twitter";
            url = "https://x.com/";
          }
          {
            name = "Prydwen";
            url = "https://prydwen.gg/";
          }
          {
            name = "osu!";
            url = "https://osu.ppy.sh/";
          }
        ];
        bookmarkFolder = id: name: guid: children: {
          inherit
            id
            name
            guid
            children
            ;
          type = "folder";
          date_added = "0";
          date_modified = "0";
        };
        bookmarksSeed = pkgs.writeText "brave-bookmarks.json" (
          builtins.toJSON {
            version = 1;
            roots = {
              bookmark_bar = bookmarkFolder "1" "Bookmarks bar" "0bc5d13f-2cba-5d74-951f-3f233fe6c908" (
                lib.imap0 (
                  index: bookmark:
                  bookmark
                  // {
                    id = toString (index + 4);
                    type = "url";
                    date_added = "0";
                  }
                ) bookmarks
              );
              other = bookmarkFolder "2" "Other bookmarks" "82b081ec-3dd3-529c-8475-ab6c344590dd" [ ];
              synced = bookmarkFolder "3" "Mobile bookmarks" "4cf2e351-0e85-532b-bb37-df045d8f8d0f" [ ];
            };
          }
        );
        browserDir = "${config.xdg.configHome}/BraveSoftware/Brave-Browser";
        wallpaper = self + /wallpapers/alpha_pgr.jpg;
        wallpaperName = builtins.baseNameOf wallpaper;

        mkWebapp = id: name: url: {
          inherit name;
          exec = "${packageFor pkgs}/bin/brave --app=${url}";
          icon = "${self}/icons/apps/${id}.png";
          categories = [ "Network" ];
          terminal = false;
        };
      in
      {
        xdg.desktopEntries = {
          youtube = mkWebapp "youtube" "YouTube" "https://www.youtube.com/";
          twitch = mkWebapp "twitch" "Twitch" "https://www.twitch.tv/";
          github = mkWebapp "github" "GitHub" "https://github.com/";
          google-calendar = mkWebapp "google-calendar" "Google Calendar" "https://calendar.google.com/";
        };

        home.activation.braveDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          # Seed only missing files, and never modify an open profile.
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
          run ${pkgs.python3}/bin/python3 ${./brave-bookmarks.py} \
            ${lib.escapeShellArg browserDir} ${bookmarksSeed} ${packageFor pkgs}/bin/brave
          if [ ! -e ${lib.escapeShellArg "${browserDir}/Default/sanitized_background_images/${wallpaperName}"} ]; then
            run ${pkgs.coreutils}/bin/install -Dm600 ${wallpaper} \
              ${lib.escapeShellArg "${browserDir}/Default/sanitized_background_images/${wallpaperName}"}
          fi
        '';
      };
  };
}
