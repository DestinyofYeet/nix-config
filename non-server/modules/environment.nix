{ ... }:
{
  systemd.user.sessionVariables = {
    # fix for gdk applications (I think)
    "GSK_RENDERER" = "gl";

    "EDITOR" = "hx";
  };
}
