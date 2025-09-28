{ pkgs, ... }: {

  boot = {
    loader.grub.configurationName = "Xanmod Bore";
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # 6.16.4
    kernelPatches = let
      patches_source = pkgs.fetchFromGitHub {
        owner = "micros24";
        repo = "linux-xanmod-bore";
        rev = "96e4c57d36e2c4895b1e479d1b253c183f6f9efa";
        hash = "sha256-PA7wG5qf2oBs/x7iorYSdfM4haTwYMtwJsCrNE529UA=";
      };
    in [
      # https://github.com/micros24/linux-xanmod-bore
      { patch = "${patches_source}/0001-bore.patch"; }
      {
        patch =
          "${patches_source}/0002-sched-fair-Prefer-full-idle-SMT-cores.patch";
      }
      { patch = "${patches_source}/0003-glitched-cfs.patch"; }
      { patch = "${patches_source}/0004-glitched-eevdf-additions.patch"; }
      { patch = "${patches_source}/0005-o3-optimization.patch"; }
    ];
  };
}
