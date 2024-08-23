{ config, pkgs, ... }:{
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ole = {
    isNormalUser = true;
    description = "ole";
    shell = pkgs.zsh;
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
    ];
    hashedPassword = "$y$j9T$crvVN5eaEGJM85SYKOAVm/$WYjB56/3GcSB5sR7/u8Ldpz0wtMcyrJWinqru/dvkB/";
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
			kdePackages.xdg-desktop-portal-kde
			kdePackages.spectacle
    ];
  };
}
