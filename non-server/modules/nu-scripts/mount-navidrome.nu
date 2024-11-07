def mount-navidrome [path: string = "/drives/navidrome"] {
  sudo mount.nfs nix-server.infra.wg:/export/navidrome ($path) -o rw,hard,intr
}
