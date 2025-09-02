{ ... }: {
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    settings = { origin_web_ui_allowed = "pc"; };
  };
}
