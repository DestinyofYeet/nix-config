{
  stable-pkgs,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  zathura = lib.getExe pkgs.zathura;
  getPdfName = pkgs.writeShellScript "get_pdf_name" ''
    file=$1

    ${zathura} "''${file%.*}.pdf"
  '';
in
{
  programs.helix = {
    enable = true;

    # until https://github.com/helix-editor/helix/pull/16348 is merged
    package = pkgs.stdenvNoCC.mkDerivation {
      name = "helix-patched";
      src = inputs.helix;
      nativeBuildInputs = [ pkgs.dasel ];
      buildPhase = ''
        cat languages.toml | dasel -i toml --root 'grammar = grammar.filter($this.name != "perl")' > languages.toml.new
        mv languages.toml.new languages.toml

        mkdir -p "$out"
        cp -r . "$out"
      '';
    };

    defaultEditor = true;

    settings = {
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "warning";
        };
        line-number = "relative";

        mouse = false;
        completion-replace = true;

        # until this stupid shit above is merged
        # word-completion = {
        #   enable = true;
        #   trigger-length = 2;
        # };

        clipboard-provider = "wayland";
      };

      theme = "tokyonight_moon";

      keys.normal = {
        space.t.y.l = '':sh ${inputs.nix-joint-venture.packages.x86_64-linux.scripts.standalone.typst_zathura_preview} "%{file_path_absolute}" 2>/dev/null &'';
        space.t.y.r = [
          ":lsp-workspace-command tinymist.doStartPreview"
          '':sh ${getPdfName} "%{file_path_absolute}" 2>/dev/null''
          ":lsp-workspace-command tinymist.doKillPreview"
        ];
        space.y.z = [
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          ":open %sh{cat /tmp/unique-file | ${lib.getExe pkgs.sd} '(?:[a-z]*:\\/\\/[a-z]*:[0-9]*:[0-9]*\\/@[\\w\\d\\.-]*\\/)([\\S| ]*)' '$1'}"
          ":redraw"
        ];
        space.y.y = ":clipboard-yank";
        ret = {
          t = [
            ":write-all"
            ":insert-output ${pkgs.serpl}/bin/serpl >/dev/tty"
            ":redraw"
            ":reload-all"
          ];
        };
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
        {
          name = "typst";
          formatter.command = "typstyle";
          language-servers = [ "tinymist" ];
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

        tinymist = {
          command = "${lib.getExe pkgs.tinymist}";
          config = {
            exportPdf = "onType";
            outputPath = "$root/$dir/$name";
          };
        };

        rust-analyzer = {
          config = {
            formatting.command = [ "${pkgs.rustfmt}/bin/rustfmt" ];
            cargo = {
              allFeatures = true;
            };
            check.command = "clippy";
          };
        };
      };
    };
  };
}
