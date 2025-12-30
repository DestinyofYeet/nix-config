let
  mapAttrs' = f: set:
    builtins.listToAttrs
    (map (attr: f attr set.${attr}) (builtins.attrNames set));

  nameValuePair = name: value: { inherit name value; };

  addPrefix = name: attrset:
    mapAttrs'
    (attr_name: attr_value: nameValuePair (name + attr_name) attr_value)
    attrset;

  importFolder = path: name: args:
    (addPrefix name (import (path + "/${name}/secrets.nix") args));
in {
  getImportFolder = path: (importFolder path);

}
