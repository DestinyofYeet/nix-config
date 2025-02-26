{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    extraPlugins = with pkgs.vimPlugins; [ material-nvim ];

    globals = { mapleader = " "; };

    opts = {
      shiftwidth = 2;
      smarttab = true;
      smartindent = false;
      number = true;
      termguicolors = true;

      clipboard.register = "unnamedplus";
      undofile = true;
      guicursor = "";
      mouse = "";
      scrolloff = 10;

      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldcolumn = "0"; # might change later
      foldtext = "";
      foldlevel = 99;
      foldlevelstart = 99;
      foldnestmax = 4;

      wildmenu = true;
      wildmode = "list:longest";
    };

    colorschemes = {
      onedark = {
        enable = false;
        settings = {
          style = "deep";
          transparent = false;
          term_colors = true;

          dagnostics = {
            darker = true;
            undercurl = true;
            background = true;
          };
        };
      };

      tokyonight = {
        enable = false;
        settings = { style = "night"; };
      };
    };

    keymaps = [
      {
        action = "<Plug>(leap)";
        key = "s";
        mode = [ "n" ];
      }
      {
        mode = [ "n" ];
        key = "<leader>c";
        action = "gcc";
        options = {
          remap = true;
          desc = "Comments out line";
        };
      }
      {
        mode = [ "v" ];
        key = "<leader>c";
        action = "<esc>:normal gvgc<CR>";
        options = { desc = "Comments out block"; };
      }
      {
        mode = [ "n" ];
        key = "<leader>nh";
        action = "<cmd>nohl<cr>";
      }
      {
        mode = [ "n" ];
        key = "<esc><esc>";
        action = "<cmd>nohl<cr>";
      }
      {
        mode = [ "x" ];
        key = ">";
        action = ">gv";
      }
      {
        mode = [ "x" ];
        key = "<";
        action = "<gv";
      }
      {
        mode = [ "n" ];
        key = "U";
        action = "<cmd>redo<cr>";
      }
      {
        mode = [ "n" ];
        key = "<leader>err";
        action.__raw =
          ''function() require("trouble").open("diagnostics") end'';
        options.desc = "Trouble: Diagnostics";
      }
      {
        mode = [ "n" ];
        key = "<leader>yz";
        action = "<cmd>Yazi<cr>";
        options.desc = "Yazi: Open";
      }
      {
        mode = [ "n" ];
        key = "<leader>fc";
        action = "za";
        options = {
          remap = true;
          desc = "Folds the code";
        };
      }
    ];

    plugins = {
      autoclose = {
        enable = true;
        settings.options = { auto_indent = false; };
      };

      leap = {
        enable = true;
        addDefaultMappings = false;
      };

      treesitter = { enable = true; };

      which-key = { enable = true; };

      lsp = {
        enable = true;

        keymaps.extra = [
          {
            mode = [ "n" ];
            key = "gr";
            action = "<cmd>Telescope lsp_references<cr>";
            options = { desc = "Show references"; };
          }
          {
            mode = [ "n" ];
            key = "gD";
            action.__raw = "vim.lsp.buf.declaration";
            options.desc = "Goto declaration";
          }
          {
            mode = [ "n" ];
            key = "gd";
            action = "<cmd>Telescope lsp_definitions<cr>";
            options.desc = "Show definitions";
          }
          {
            mode = [ "n" ];
            key = "<leader>rn";
            action.__raw = "vim.lsp.buf.rename";
            options.desc = "Rename symbol";
          }
          {
            mode = [ "n" ];
            key = "<leader>dD";
            action = "<cmd>FzfLua diagnostics_document<cr>";
            options.desc = "Show buffer diagnostics";
          }
          {
            mode = [ "n" ];
            key = "<leader>dd";
            action.__raw = "vim.diagnostic.open_float";
            options.desc = "Show line diagnostics";
          }
          {
            mode = [ "n" ];
            key = "<leader>k";
            action.__raw = "vim.lsp.buf.hover";
            options.desc = "Show documentation";
          }
          {
            mode = [ "n" ];
            key = "<leader>a";
            action = "<cmd>FzfLua lsp_code_actions<cr>";
            options.desc = "Performs code action";
          }
        ];

        servers = {
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
            installRustfmt = false;
          };
          nil_ls = {
            enable = true;
            extraOptions = { nix.flake.autoArchive = true; };
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lspFallback = true;
            timeoutMs = 500;
          };
          formatters_by_ft = {
            rust = [ "rustfmt" ];
            nix = [ "nixfmt" ];
          };

          notify_on_error = true;
        };
      };

      web-devicons = {
        enable = true;
        settings = { color_icons = true; };
      };

      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          live-grep-args.enable = true;
          file-browser.enable = true;
        };

        luaConfig.post = ''
          local builtin = require("telescope.builtin")
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "Telescope: Find files"})
          vim.keymap.set('n', '<leader>fa', builtin.live_grep, {desc = "Telescope: Live grep"})
        '';

        settings = {
          defaults = {
            file_ignore_patterns = [ "^.git/" "^.mypy_cache" "^__pycache__/" ];

            layout_config = { prompt_position = "top"; };
          };
        };
      };

      guess-indent = { enable = true; };

      lualine = {
        enable = true;
        settings = { options = { theme = "nightfly"; }; };
      };

      # trouble = {
      #   enable = true;
      # };
      barbar = {
        enable = true;
        settings = { animations = true; };

        luaConfig.post = ''
          vim.api.nvim_create_autocmd('WinClosed', {
            callback = function(tbl)
              if tbl.args ~= nil then
                vim.api.nvim_command('BufferClose ' .. tbl.args)
              end
            end,
            group = vim.api.nvim_create_augroup('barbar_close_buf', {})
          })
        '';

        keymaps = {
          close = {
            key = "<leader>bc";
            options.desc = "BarBar: Closes buffer";
          };
          goTo1 = {
            key = "<leader>1";
            options.desc = "BarBar: Goto 1 tab";
          };
          goTo2 = {
            key = "<leader>2";
            options.desc = "BarBar: Goto 2 tab";
          };
          goTo3 = {
            key = "<leader>3";
            options.desc = "BarBar: Goto 3 tab";
          };
          goTo4 = {
            key = "<leader>4";
            options.desc = "BarBar: Goto 4 tab";
          };
          goTo5 = {
            key = "<leader>5";
            options.desc = "BarBar: Goto 5 tab";
          };
          goTo6 = {
            key = "<leader>6";
            options.desc = "BarBar: Goto 6 tab";
          };
          goTo7 = {
            key = "<leader>7";
            options.desc = "BarBar: Goto 7 tab";
          };
          goTo8 = {
            key = "<leader>8";
            options.desc = "BarBar: Goto 8 tab";
          };
          goTo9 = {
            key = "<leader>9";
            options.desc = "BarBar: Goto 9 tab";
          };
        };
      };

      yazi = { enable = true; };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources =
          [ { name = "nvim_lsp"; } { name = "path"; } { name = "buffer"; } ];
      };

      fzf-lua = { enable = true; };
    };

    extraConfigLua = ''
      require("material").setup({
        disable = {
          colored_cursor = true,
        },
      })
      vim.g.material_style = "deep ocean"
      vim.cmd 'colorscheme material'
    '';
  };
}
