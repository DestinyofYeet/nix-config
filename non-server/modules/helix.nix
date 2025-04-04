{ pkgs, ... }:
let
  typst-watch-script = pkgs.writeShellScript "watch-typst.sh" ''
    dir=$(${pkgs.mktemp}/bin/mktemp -d)
    _=$(${pkgs.typst}/bin/typst watch "$1" "$dir/tmp.pdf" & echo $! > "$dir/pid")&
    until [ -f "$dir/tmp.pdf" ]
    do
      sleep 0.5
    done
    pid=$(${pkgs.coreutils}/bin/cat "$dir/pid")
    ${pkgs.zathura}/bin/zathura "$dir/tmp.pdf"
    kill "$pid"
    rm -fr "$dir"
  '';
in {
  programs.helix = {
    enable = true;

    defaultEditor = true;

    settings = {
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = { cursor-line = "warning"; };

        mouse = false;
      };

      theme = "tokyonight_moon";

      keys.normal = {
        space.t.y = ":sh ${typst-watch-script} %{buffer_name} 2>/dev/null &";
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
