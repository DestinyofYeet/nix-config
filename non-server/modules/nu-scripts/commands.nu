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
  systemctl --user restart waybar
}

def restart-ashell [] {
  systemctl --user restart ashell
}

def "launch obsidian" [] {
  task spawn --immediate --label obsidian { LANG=DE obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 }
}

def "launch anki" [] {
  task spawn --immediate --label anki { ANKI_WAYLAND=1 anki }
}

def find_terminal [] {
  if ($env | get -o TERM_PROGRAM) != null {
    return $env.TERM_PROGRAM
  }

  if $env.TERM == "xterm-kitty" {
    return "kitty"
  }

  return "unknown"
}


let path = (get-random-file /home/ole/deposit/Images/nyan_cats).name;

let terminal = find_terminal;

if $terminal == "WezTerm" {
  wezterm imgcat $path
} else if $terminal == "kitty" {
  icat $path
}

