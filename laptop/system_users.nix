{ config, pkgs, ... }:{
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ole = {
    isNormalUser = true;
    description = "ole";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
			kdePackages.xdg-desktop-portal-kde
			kdePackages.spectacle
    ];
  };
}
