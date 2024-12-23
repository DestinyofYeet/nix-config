{
  pkgs,
  ...
}:{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  # environment.systemPackages = with pkgs; [
  #   fcitx5-config-qt
  # ];
  
  environment.variables = {
    GLFW_IM_MODULE = "ibus";
    QT_IM_MODULE = "fcitx";
    QT_QPA_PLATFORM = "xcb";
  };
}
