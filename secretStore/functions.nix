{
  path ? ./.,
}:
let
  mapAttrs' = f: set: builtins.listToAttrs (map (attr: f attr set.${attr}) (builtins.attrNames set));

  nameValuePair = name: value: { inherit name value; };
in
rec {
  addPrefix =
    name: attrset:
    mapAttrs' (attr_name: attr_value: nameValuePair (name + attr_name) attr_value) attrset;

  importFolder = name: args: (addPrefix name (import (path + "/${name}/secrets.nix") args));
}
