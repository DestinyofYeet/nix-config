{ nixpkgs, }:
let defaultCapabilities = import ./capabilities.nix;
in {
  mkHost = { system, specialArgs, modules, capabilities }:

    let
      mergedCapabilities = defaultCapabilities // capabilities;
      mergedSpecialArgs = specialArgs // { capabilities = mergedCapabilities; };

    in assert (mergedCapabilities.headless.enable
      != mergedCapabilities.monitor.enable) || throw ''
        headless.enable cannot be the same as monitor.enable!
        Enable on of them.'';

    nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = mergedSpecialArgs;
    };
}
