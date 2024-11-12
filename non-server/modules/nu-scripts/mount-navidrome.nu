def mount-navidrome [path: string = "/drives/navidrome"] {
  sudo mount.nfs nix-server.infra.wg:/mnt/data/data/media/navidrome ($path) -o rw,hard,intr
}
