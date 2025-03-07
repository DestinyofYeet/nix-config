def mount-navidrome [path: string = "/drives/navidrome"] {
  sudo mount.nfs nix-server.neb.ole.blue:/mnt/data/data/media/navidrome ($path) -o rw,hard,intr
}

def mount-programmingStuff [path: string = "/drives/programmingStuff"] {
  sudo mount.nfs nix-server.neb.ole.blue:/mnt/data/data/programmingStuff ($path) -o rw,hard,intr
}
