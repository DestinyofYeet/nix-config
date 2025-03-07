{ keys }:
let authed = keys.authed ++ [ keys.systems.bonk ];
in { "nextcloud-root-pw.age".publicKeys = authed; }
