{keys}: let
  functions = import ../functions.nix {path = ./.;};
  authed = keys.authed;
in
  {
    "stalwart-ole-pw.age".publicKeys = authed;
    "nix-config-file.age".publicKeys = authed;

    "ssh-key-github-signing.age".publicKeys = authed;

    "oth-regensburg-email-pw.age".publicKeys = authed;

    "email-uwuwhatsthis-pw.age".publicKeys = authed;

    "taskwarrior-config.age".publicKeys = authed;
  }
  // (functions.importFolder "main/" {inherit keys;})
  // (functions.importFolder "wattson/" {inherit keys;})
  // (functions.importFolder "kartoffelkiste/" {inherit keys;})
