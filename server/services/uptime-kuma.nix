{ ... }:{
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
    };
  };
}
