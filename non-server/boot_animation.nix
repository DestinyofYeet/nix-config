{ pkgs, ... }: {

  services.bootvine = {
    enable = true;
  };

  boot = {
    plymouth = {
      enable = false;
      themePackages = with pkgs; [ adi1090x-plymouth-themes ];
      theme = "connect";
    };
  };
}
