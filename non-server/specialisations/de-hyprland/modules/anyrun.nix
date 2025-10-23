{ inputs, pkgs, secretStore, config, lib, ... }:
let
  startVpnScript =
    lib.custom.scripts.startOpenfortiVpn config.age.secrets.openfortivpn.path;
  stopVpnScript = lib.custom.scripts.stopOpenfortiVpn;
in {
  age.secrets = {
    openfortivpn.file = secretStore.nonServer + "/openfortivpn-config.age";
  };

  programs.anyrun = rec {
    enable = true;

    package = pkgs.anyrun;

    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.5; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = null;

      # plugins = with inputs.anyrun.packages.${pkgs.system}; [
      #   applications
      #   shell
      #   rink
      #   stdin
      #   symbols
      #   randr
      # ];

      plugins = [
        "${package}/lib/libapplications.so"
        "${package}/lib/libshell.so"
        "${package}/lib/libnix_run.so"
        "${package}/lib/librink.so"
        "${package}/lib/libsymbols.so"
        "${inputs.anyrun-custom-command.packages.x86_64-linux.default}/lib/libcustom_command.so"
      ];
    };

    extraConfigFiles = {
      # needs to include all config in the config file. Otherwise it failes silently and loads default values
      "symbols.ron".text = ''
        Config(
          prefix: ":sym",

          symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
            },
            max_entries: 10,
        )
      '';

      "custom-command.ron".text = ''
        Config(
          prefix: ":cc",
          commands: [
            Entry(
              title: "obsidian",
              description: "Launch obsidian",
              exec: Some("obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3"),
              envs: Some([
                ("LANG", "DE")
              ]),
            ),

            Entry(
              title: "vpn",
              description: "Openfortivpn Options",
              subcommands: Some([
                Entry(
                  title: "Start",
                  description: "Start",
                  exec: Some("${startVpnScript}"),
                  print_output: Some(true),
                ),
                Entry(     
                  title: "Stop",
                  description: "Stop",
                  exec: Some("${stopVpnScript}"),
                  print_output: Some(true),
                )
              ])
            ),

            Entry(
              title: "testettest",
              description: "A test",
              subcommands: Some([
                Entry(
                  title: "Test level 1",
                  description: "test level 1",
                  subcommands: Some([
                    Entry(
                      title: "Test level 2",
                      description: "Test level 2",
                    )
                  ])
                )
              ])
            )
          ]
        )
      '';

      "nix-run.ron".text = ''
        Config(
          prefix: ":run",
          allow_unfree: true,
          channel: "nixpkgs-unstable",
          max_entries: 10,
        )
      '';
    };

    extraCss = ''
      /* ===== Color variables ===== */
      :root {
        --bg-color: #313244;
        --fg-color: #cdd6f4;
        --primary-color: #89b4fa;
        --secondary-color: #cba6f7;
        --border-color: var(--primary-color);
        --selected-bg-color: var(--primary-color);
        --selected-fg-color: var(--bg-color);
      }

      /* ===== Global reset ===== */
      * {
        all: unset;
        font-family: "JetBrainsMono Nerd Font", monospace;
      }

      /* ===== Transparent window ===== */
      window {
        background: transparent;
      }

      /* ===== Main container ===== */
      box.main {
        border-radius: 16px;
        background-color: color-mix(in srgb, var(--bg-color) 80%, transparent);
        border: 0.5px solid color-mix(in srgb, var(--fg-color) 25%, transparent);
        padding: 12px; /* add uniform padding around the whole box */
      }

      /* ===== Input field ===== */
      text {
        font-size: 1.3rem;
        background: transparent;
        border: 1px solid var(--border-color);
        border-radius: 16px;
        margin-bottom: 12px;
        padding: 5px 10px;
        min-height: 20x;
        caret-color: var(--primary-color);
      }

      /* ===== List container ===== */
      .matches {
        background-color: transparent;
      }

      /* ===== Single match row ===== */
      .match {
        font-size: 1.1rem;
        padding: 4px 10px; /* tight vertical spacing */
        border-radius: 6px;
      }

      /* Remove default label margins */
      .match * {
        margin: 0;
        padding: 0;
        line-height: 1;
      }

      /* Selected / hover state */
      .match:selected,
      .match:hover {
        background-color: var(--selected-bg-color);
        color: var(--selected-fg-color);
      }

      .match:selected label.plugin.info,
      .match:hover label.plugin.info {
        color: var(--selected-fg-color);
      }

      .match:selected label.match.description,
      .match:hover label.match.description {
        color: color-mix(in srgb, var(--selected-fg-color) 90%, transparent);
      }

      /* ===== Plugin info label ===== */
      label.plugin.info {
        color: var(--fg-color);
        font-size: 1rem;
        min-width: 160px;
        text-align: left;
      }

      /* ===== Description label ===== */
      label.match.description {
        font-size: 0.8rem;
        color: var(--fg-color);
      }

      /* ===== Fade-in animation ===== */
      @keyframes fade {
        0% {
          opacity: 0;
        }
        100% {
          opacity: 1;
        }
      }


    '';
  };
}
