{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    defaultEditor = true;

    settings = {
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = { cursor-line = "warning"; };
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
