{ ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {

    acceptTerms = true;
    defaults = { email = "ole@ole.blue"; };
  };
}
