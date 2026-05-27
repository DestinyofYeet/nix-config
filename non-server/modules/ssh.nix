{
  config,
  osConfig,
  lib,
  custom,
  secretStore,
  rlib,
  ...
}:
let
  per-device-secrets = secretStore.secrets + "/non-server/${osConfig.networking.hostName}";

  mkSecrets =
    names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = {
          file = "${per-device-secrets}/${name}.age";
        };
      }) (builtins.filter (name: builtins.pathExists "${per-device-secrets}/${name}.age") names)
    );

  buildHost =
    {
      host,
      hostname,
      user,
      ident ? null,
      port ? 22,
      extra ? { },
    }:
    {
      "${host}" = rlib.mkMerge [
        {
          Hostname = hostname;
          User = user;
          Port = port;
        }

        (rlib.mkIf (ident != null && (builtins.hasAttr "${ident}" config.age.secrets)) {
          IdentityFile = config.age.secrets.${ident}.path;
        })

        extra
      ];
    };

  mkHost =
    host:
    let
      cleanHost =
        attr:
        removeAttrs attr [
          "extraHosts"
          "aliases"
        ];
    in
    rlib.mkMerge [
      (rlib.mkIf (builtins.hasAttr "extraHosts" host) (
        builtins.mapAttrs (name: value: value.${name}) (
          lib.mapAttrs' (
            name: value:
            let
              newHost = "${host.host}-${name}";
              newValue = value // {
                host = newHost;
              };
            in
            lib.nameValuePair newHost (buildHost (cleanHost (host // newValue)))
          ) host.extraHosts
        )
      ))

      (rlib.mkIf (builtins.hasAttr "aliases" host) (
        builtins.mapAttrs (name: value: value.${name}) (
          builtins.listToAttrs (
            map (alias: {
              name = alias;
              value = mkHost (cleanHost (host // { host = alias; }));
            }) host.aliases
          )
        )
      ))

      (buildHost (cleanHost host))
    ];

  nebulaHosts = custom.nebula.yeet.hosts;
in
{
  age.secrets = mkSecrets [
    "ssh-key-oth-gitlab"
    "ssh-key-github"
    "ssh-key-fsim-ori"
    "ssh-key-vps-main"
    "ssh-key-nix-server"
    "ssh-key-fsim-backup"
    "ssh-key-fsim-pedro"
    "ssh-key-vps-teapot"
    "ssh-key-gitea"
    "ssh-key-nixie"
  ];

  programs.ssh = {
    enable = true;
    settings = rlib.mkMerge [
      (mkHost rec {
        host = "github.com";
        hostname = host;
        user = "git";
        ident = "ssh-key-github";
      })

      (mkHost rec {
        host = "gitlab.oth-regensburg.de";
        hostname = host;
        user = "git";
        ident = "ssh-key-oth-gitlab";
      })

      (mkHost rec {
        host = "git.oth-service.de";
        hostname = host;
        user = "git";
        ident = "ssh-key-gitea";
      })

      (mkHost rec {
        host = "code.ole.blue";
        aliases = [ "git.ole.blue" ];
        hostname = host;
        user = "forgejo";
        ident = "ssh-key-gitea";

        extraHosts = {
          wg = {
            hostname = nebulaHosts.teapot.ip;
          };
        };
      })

      (mkHost {
        host = "bonk";
        user = "root";
        hostname = "uwuwhatsthis.de";
        ident = "ssh-key-vps-main";

        extraHosts = {
          wg = {
            hostname = nebulaHosts.bonk.ip;
          };
        };
      })

      (mkHost {
        host = "teapot";
        hostname = "ole.blue";
        user = "root";
        ident = "ssh-key-vps-teapot";

        extraHosts = {
          wg = {
            hostname = nebulaHosts.teapot.ip;
          };
        };
      })

      (mkHost {
        host = "nix-server";
        hostname = nebulaHosts.nix-server.ip;
        user = "root";
        ident = "ssh-key-nix-server";
      })

      (mkHost {
        host = "nixie";
        hostname = "192.168.1.129";
        user = "root";
        ident = "ssh-key-nixie";

        extraHosts = {
          wg = {
            hostname = nebulaHosts.nixie.ip;
          };
        };
      })

      (mkHost {
        host = "fsim.backup";
        hostname = "wiki.fsim";
        user = "ole";
        ident = "ssh-key-fsim-backup";

        extraHosts = {
          via-pedro = {
            hostname = "10.24.0.1";
            extra = {
              ProxyJump = "fsim.pedro";
            };
          };
        };
      })

      (mkHost {
        host = "fsim.pedro";
        hostname = "fsim-ev.de";
        user = "beo45216";
        ident = "ssh-key-fsim-pedro";
        port = 8081;
      })

      (mkHost {
        host = "fsim.apollo";
        hostname = "apollo";
        user = "beo45216";

        extraHosts = {
          via-pedro-via-backup = {
            extra = {
              ProxyJump = "fsim.backup-via-pedro";
            };
          };
        };
      })
    ];
  };
}
