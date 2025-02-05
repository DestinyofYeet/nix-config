def cnetstat [ --root ] {
  let command = if $root { sudo netstat -tulpn } else { netstat -tulpn }
  $command | str replace "Local Address" "local_address" | str replace "Foreign Address" "foreign_address" | detect columns --skip 1
}

def get-random-file [path: string] {
  let files = ls $path;
  let length = ($files | length) - 1;

  $files | get (random int 0..$length)
}

def restart-waybar [] {
  pkill waybar
  task spawn { waybar }
}

def "launch obsidian" [] {
  task spawn { LANG=DE obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 }
}

def "launch anki" [] {
  task spawn { ANKI_WAYLAND=1 anki }
}

icat (get-random-file /home/ole/Nextcloud/Images/nyan_cats).name;

