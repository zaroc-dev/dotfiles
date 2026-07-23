{ ... }:
{
  flake.homeModules.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        globals = {
          mapleader = " ";
          maplocalleader = " ";
          loaded_netrw = 1;
          loaded_netrwPlugin = 1;
        };

        opts = {
          number = true;
          relativenumber = true;
          cursorline = true;
          signcolumn = "yes";
          scrolloff = 8;
          sidescrolloff = 8;
          shiftwidth = 4;
          tabstop = 4;
          softtabstop = 4;
          expandtab = true;
          smartindent = true;
          ignorecase = true;
          smartcase = true;
          inccommand = "split";
          splitbelow = true;
          splitright = true;
          mouse = "a";
          undofile = true;
          updatetime = 250;
          timeoutlen = 300;
          completeopt = [ "menu" "menuone" "noselect" ];
          wrap = false;
          clipboard = "unnamedplus";
          showmode = false;
          fillchars = { eob = " "; };
        };

        keymaps = [
          {
            mode = "n";
            key = "<leader>cd";
            action = "<cmd>Ex<cr>";
            options.desc = "Open netrw";
          }
          {
            mode = "n";
            key = "<A-Up>";
            action = "<cmd>m .-2<cr>==";
            options.desc = "Move line up";
          }
          {
            mode = "n";
            key = "<A-Down>";
            action = "<cmd>m .+1<cr>==";
            options.desc = "Move line down";
          }
          {
            mode = "v";
            key = "<A-Up>";
            action = ":m '<-2<CR>gv=gv";
            options.desc = "Move selection up";
          }
          {
            mode = "v";
            key = "<A-Down>";
            action = ":m '>+1<CR>gv=gv";
            options.desc = "Move selection down";
          }
          {
            mode = "n";
            key = "<C-Right>";
            action = "<C-w><C-l>";
            options.desc = "Move focus to the right window";
          }
          {
            mode = "n";
            key = "<C-Left>";
            action = "<C-w><C-h>";
            options.desc = "Move focus to the left window";
          }
          {
            mode = "n";
            key = "<C-Down>";
            action = "<C-w><C-j>";
            options.desc = "Move focus to the lower window";
          }
          {
            mode = "n";
            key = "<C-Up>";
            action = "<C-w><C-k>";
            options.desc = "Move focus to the upper window";
          }
          {
            mode = "x";
            key = "<leader>p";
            action = ''"_dP'';
            options.desc = "Paste without replacing the default register";
          }
          {
            mode = "n";
            key = "<leader>y";
            action = ''"+y'';
            options.desc = "Yank to system clipboard";
          }
          {
            mode = "v";
            key = "<leader>y";
            action = ''"+y'';
            options.desc = "Yank to system clipboard";
          }
          {
            mode = "n";
            key = "<leader>Y";
            action = ''"+Y'';
            options.desc = "Yank to system clipboard (line)";
          }
          {
            mode = "n";
            key = "<leader>d";
            action = ''"_d'';
            options.desc = "Delete without replacing the default register";
          }
          {
            mode = "v";
            key = "<leader>d";
            action = ''"_d'';
            options.desc = "Delete without replacing the default register";
          }
          {
            mode = "n";
            key = "<Esc>";
            action = "<cmd>nohlsearch<cr>";
          }
          {
            mode = [ "i" "x" "n" "s" ];
            key = "<C-s>";
            action = "<cmd>w<cr><esc>";
            options.desc = "Save File";
          }
          {
            mode = "n";
            key = "<leader>fn";
            action = ":e %:h/";
            options.desc = "New file in current dir";
          }
        ];

        autoCmd = [
          {
            event = [ "FileType" ];
            pattern = [ "markdown" "text" "gitcommit" ];
            callback.__raw = ''
              function()
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
                vim.opt_local.spell = true
              end
            '';
          }
          {
            event = [ "LspAttach" ];
            desc = "LSP actions";
            callback.__raw = ''
              function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
              end
            '';
          }
        ];

        extraPlugins = with pkgs.vimPlugins; [
          rust-vim
        ];

        extraPackages = with pkgs; [
          csharpier
          nil
          nixfmt-rfc-style
          prettierd
          ruff
          rust-analyzer
          stylua
          svelte-language-server
          typescript-language-server
          vscode-langservers-extracted
        ];

        colorschemes.catppuccin = {
          enable = true;
          settings.transparent_background = true;
        };

        plugins = {
          web-devicons.enable = true;
          comment.enable = true;
          nvim-surround.enable = true;
          lazygit.enable = true;
          luasnip.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-buffer.enable = true;
          cmp-path.enable = true;
          cmp_luasnip.enable = true;
          rustaceanvim.enable = true;

          cmp = {
            enable = true;
            settings = {
              snippet.expand.__raw = ''
                function(args)
                  require("luasnip").lsp_expand(args.body)
                end
              '';
              mapping = {
                "<C-Space>".__raw = "cmp.mapping.complete()";
                "<C-e>".__raw = "cmp.mapping.abort()";
                "<CR>".__raw = "cmp.mapping.confirm({ select = true })";
                "<Tab>".__raw = "cmp.mapping.select_next_item()";
                "<S-Tab>".__raw = "cmp.mapping.select_prev_item()";
              };
              sources = [
                { name = "nvim_lsp"; }
                { name = "luasnip"; }
                { name = "buffer"; }
                { name = "path"; }
              ];
            };
          };

          conform-nvim = {
            enable = true;
            settings = {
              formatters_by_ft = {
                lua = [ "stylua" ];
                javascript = [ "prettierd" ];
                typescript = [ "prettierd" ];
                javascriptreact = [ "prettierd" ];
                typescriptreact = [ "prettierd" ];
                svelte = [ "prettierd" ];
                css = [ "prettierd" ];
                html = [ "prettierd" ];
                json = [ "prettierd" ];
                yaml = [ "prettierd" ];
                markdown = [ "prettierd" ];
                markdown_inline = [ "prettierd" ];
                nix = [ "nixfmt" ];
                python = [ "ruff" ];
              };
              format_on_save = {
                timeout_ms = 500;
                lsp_fallback = true;
              };
            };
          };

          flash = {
            enable = true;
            settings = { };
          };

          gitsigns = {
            enable = true;
            settings = {
              current_line_blame = true;
              current_line_blame_opts.delay = 500;
              on_attach.__raw = ''
                function(bufnr)
                  local gs = require("gitsigns")
                  local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                  end
                  map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
                  map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
                  map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage hunk")
                  map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
                  map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                  map("n", "<leader>gb", gs.blame_line, "Blame line")
                  map("n", "<leader>gd", gs.diffthis, "Diff file")
                end
              '';
            };
          };

          indent-blankline = {
            enable = true;
            settings.scope.enabled = true;
          };

          lsp = {
            enable = true;
            inlayHints = true;
            servers = {
              ts_ls.enable = true;
              svelte.enable = true;
              yamlls.enable = true;
              omnisharp.enable = true;
              lua_ls.enable = true;
              ruff.enable = true;
              nil_ls.enable = true;
            };
            onAttach = ''
              if client.name == "svelte" then
                client.server_capabilities.semanticTokensProvider = nil
              end
            '';
            capabilities = ''
              capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            '';
          };

          lualine = {
            enable = true;
            settings.options = {
              theme = "auto";
              globalstatus = true;
            };
          };

          neo-tree = {
            enable = true;
            settings = {
              close_if_last_window = true;
              window.width = 30;
              filesystem.filtered_items = {
                visible = true;
                hide_dotfiles = false;
                hide_gitignored = true;
              };
            };
          };

          noice = {
            enable = true;
            settings = {
              lsp = {
                progress.enabled = true;
                override = {
                  "vim.lsp.util.convert_input_to_markdown_lines" = true;
                  "vim.lsp.util.set_autocmd_total" = true;
                  "ui.configuration.lsp_doc_border" = true;
                };
              };
              presets = {
                bottom_search = false;
                command_palette = true;
                long_message_to_split = true;
                inc_rename = false;
                lsp_doc_border = true;
              };
            };
          };

          notify = {
            enable = true;
            settings = {
              timeout = 3000;
              background_colour = "#000000";
              render = "compact";
            };
          };

          render-markdown = {
            enable = true;
            settings = {
              completions.lsp.enabled = true;
              heading.sign = false;
              code = {
                sign = false;
                width = "block";
                right_pad = 1;
              };
            };
          };

          telescope = {
            enable = true;
            settings = {
              defaults.mappings.i = {
                "<C-j>" = "move_selection_next";
                "<C-k>" = "move_selection_previous";
              };
              pickers.find_files.hidden = true;
            };
          };

          todo-comments.enable = true;

          toggleterm = {
            enable = true;
            settings = {
              direction = "float";
              open_mapping = "<C-\\\\>";
              float_opts.border = "curved";
            };
          };

          treesitter = {
            enable = true;
            settings = {
              highlight.enable = true;
              indent.enable = true;
            };
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              bash
              c
              c_sharp
              html
              javascript
              json
              lua
              markdown
              markdown_inline
              nix
              python
              regex
              rust
              svelte
              tsx
              typescript
              vim
              vimdoc
              yaml
            ];
          };

          ts-autotag.enable = true;

          trouble = {
            enable = true;
            settings = { };
          };

          which-key = {
            enable = true;
            settings = {
              preset = "classic";
              spec = [
                { __unkeyed-1 = "<leader>f"; group = "Find"; }
                { __unkeyed-1 = "<leader>c"; group = "Code"; }
                { __unkeyed-1 = "<leader>g"; group = "Git"; }
                { __unkeyed-1 = "<leader>x"; group = "Diagnostics"; }
                { __unkeyed-1 = "<leader>t"; group = "Toggle / Terminal"; }
                { __unkeyed-1 = "<leader>r"; group = "Rename"; }
                { __unkeyed-1 = "<leader>y"; group = "Yank (Clipboard)"; }
                { __unkeyed-1 = "<leader>d"; group = "Delete (No Register)"; }
              ];
            };
          };
        };

        extraConfigLua = ''
          vim.diagnostic.config({
            virtual_text = { prefix = "●" },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          })

          local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
          end

          pcall(vim.treesitter.language.register, "svelte", "svelte")

          local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
          if telescope_ok then
            vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Help tags" })
            vim.keymap.set("n", "<leader>fr", telescope_builtin.oldfiles, { desc = "Recent files" })
            vim.keymap.set("n", "<leader>fc", telescope_builtin.commands, { desc = "Commands" })
            vim.keymap.set("n", "<leader>fs", telescope_builtin.lsp_document_symbols, { desc = "Document symbols" })
            vim.keymap.set("n", "<leader>fS", telescope_builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
            vim.keymap.set("n", "<leader>/", telescope_builtin.current_buffer_fuzzy_find, { desc = "Search buffer" })
          end

          vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle File Explorer" })
          vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
          vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Floating terminal" })
          vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
          vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
          vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
          vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Document symbols" })
          vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
          vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
          vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
          vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "TODO list" })
          vim.keymap.set("n", "s", function() require("flash").jump() end, { desc = "Flash jump" })
          vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
        '';
      };
    };
}
