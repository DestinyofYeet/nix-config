{ pkgs, ... }:
let
  typst-watch-script = pkgs.writeShellScript "watch-typst.sh" ''
    dir=$(mktemp -d)
    _=$(typst watch "$1" "$dir/tmp.pdf" & echo $! > "$dir/pid")&
    until [ -f "$dir/tmp.pdf" ]
    do
      sleep 0.5
    done
    pid=$(cat "$dir/pid")
    zathura "$dir/tmp.pdf"
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
      };

      keys.normal = {
        space.t.y = ":sh ${typst-watch-script} %{buffer_name} 2>/dev/null &";
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

    settings = {
      theme = "tokyonight_moon";

      editor = { mouse = false; };
    };
  };
}
