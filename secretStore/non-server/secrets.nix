{ keys, functions, ... }@inputs:
let authed = keys.authed;
in {
  "stalwart-ole-pw.age".publicKeys = authed;
  "nix-config-file.age".publicKeys = authed;

  "ssh-key-github-signing.age".publicKeys = authed;

  "oth-regensburg-email-pw.age".publicKeys = authed;

  "email-ole-blue-pw.age".publicKeys = authed;

  "taskwarrior-config.age".publicKeys = authed;

  "openfortivpn-config.age".publicKeys = authed;
} // (functions.importFolder "main/" inputs)
// (functions.importFolder "wattson/" inputs)
// (functions.importFolder "kartoffelkiste/" inputs)
