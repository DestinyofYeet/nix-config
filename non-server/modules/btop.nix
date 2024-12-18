{ pkgs, ... }:
{
  programs.btop = {
    enable = true;

    # package = pkgs.btop.overrideAttrs (oldAttrs: {
    # cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
    # "-DBTOP_RSMI_STATIC=ON"
    # "-DBTOP_GPU=ON"
    # ];
    # });

    settings = {
      truecolor = true;
      update_ms = 1000;
    };
  };
}
