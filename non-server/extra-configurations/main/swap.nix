{ ... }: {
  # https://discourse.nixos.org/t/how-to-add-a-swap-after-nixos-installation/41742
  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024; # 32GB
  }];
}
