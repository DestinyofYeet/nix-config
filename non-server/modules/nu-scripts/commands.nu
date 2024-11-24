def cnetstat [ --root ] {
  let command = if $root { sudo netstat -tulpn } else { netstat -tulpn }
  $command | str replace "Local Address" "local_address" | str replace "Foreign Address" "foreign_address" | detect columns --skip 1
}

def rebuild-system [ args?:string ] {
  sudo -v; sudo nixos-rebuild build --flake /home/ole/nixos# --log-format internal-json -v o+e>| nom --json
}

def test-system [] {
  sudo -v; sudo nixos-rebuild test --flake /home/ole/nixos# --log-format internal-json -v o+e>| nom --json
}
