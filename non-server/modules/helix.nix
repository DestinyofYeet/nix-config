{ pkgs, inputs, ... }: {
  programs.helix = {
    enable = true;

    package = pkgs.evil-helix;

    defaultEditor = true;

    settings = {
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = { cursor-line = "warning"; };
        line-number = "relative";

        mouse = false;
      };

      theme = "tokyonight_moon";

      keys.normal = {
        space.t.y =
          ":sh ${inputs.nix-joint-venture.packages.x86_64-linux.scripts.standalone.typst_zathura_preview} %{buffer_name} 2>/dev/null &";
        space.y.z = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
        ];
        space.y.y = ":clipboard-yank";
      };
    };

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
      ];

      language-server = {
        nil = {
          config.nil = {
            formatting.command = [ "nixfmt" ];

            nix = {
              maxMemoryMB = 10000;
              flake = {
                autoArchive = true;
                autoEvalInputs = false;
              };
            };
          };
        };

        rust-analyzer = {
          config = {
            formatting.command = [ "${pkgs.rustfmt}/bin/rustfmt" ];
            cargo = { allFeatures = true; };
          };
        };
      };
    };
  };
}
