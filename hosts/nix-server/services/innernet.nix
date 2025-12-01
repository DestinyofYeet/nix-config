{ pkgs, ... }:
{
  systemd.services.innernet-infra = {
    description = "innernet client for infra";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "nss-lookup.target"
    ];
    wants = [
      "network-online.target"
      "nss-lookup.target"
    ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.innernet}/bin/innernet up infra --daemon --interval 60 --no-write-hosts";
    };
  };
}
