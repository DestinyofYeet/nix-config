let
  system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEqmDnGXPNc+Z1DRHVRRqik2WpeGjVoSOdKi1baXafH root@teapot";

  system_ole = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3srCH9OXTJcTRqBPfEkVuVM0zV2mgrzLncHY2rwEUC ole@teapot";

  ole_laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  ole_main = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";

  authed = [ system system_ole ole_laptop ole_main ];

in {
  "ole-ole.blue.age".publicKeys = authed;
  "scripts-uwuwhatsthis.de.age".publicKeys = authed;
  "sonarr-uwuwhatsthis.de.age".publicKeys = authed;
  "prowlarr-uwuwhatsthis.de.age".publicKeys = authed;
  "uptime-kuma-uwuwhatsthis.de.age".publicKeys = authed;
  "zed-uwuwhatsthis.de.age".publicKeys = authed;
}
