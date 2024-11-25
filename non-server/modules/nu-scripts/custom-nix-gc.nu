def main [amount_to_keep: int = 10] {
  let amount_of_systems = (ls /nix/var/nix/profiles/system* | length);

  let deletion_amount = $amount_of_systems - $amount_to_keep

  if $deletion_amount < 1 {
    print $"Not enough systems to delete. Found ($amount_of_systems) but need to delete ($amount_to_keep)"
    exit 0
  }

  print $"Found ($amount_of_systems) generations. Keeping ($amount_to_keep), need to delete ($deletion_amount)"

  let systems = (ls /nix/var/nix/profiles/system* | sort-by modified)

  for index in 0..$deletion_amount {
    sudo rm -fr (($systems | get $index).name)
  }

  sudo nix-collect-garbage
}
