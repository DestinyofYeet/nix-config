def cnetstat [ --root ] {
  let command = if $root { sudo netstat -tulpn } else { netstat -tulpn }
  $command | str replace "Local Address" "local_address" | str replace "Foreign Address" "foreign_address" | detect columns --skip 1
}

def --wrapped system-command [ function: string, ...args ] {
  sudo -v
  sudo nixos-rebuild $function ...$args --flake /home/ole/nixos# --log-format internal-json -v o+e>| nom --json
}

def --wrapped rebuild-system [ ...args ] {
  system-command switch ...$args
}

def --wrapped test-system [ ...args ] {
  system-command test ...$args
}
