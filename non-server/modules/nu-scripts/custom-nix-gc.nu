def cleanup_profiles [name: string, systems, amount_to_keep: int] {
  let amount_of_systems = ($systems | length);

  let deletion_amount = $amount_of_systems - $amount_to_keep

  if $deletion_amount < 1 {
    print $"($name): Not enough systems to delete. Found ($amount_of_systems) but need to delete ($amount_to_keep)"
    return
  }

  print $"($name): Found ($amount_of_systems) generations. Keeping ($amount_to_keep), need to delete ($deletion_amount)"

  let systems = ($systems | sort-by modified)

  for index in 0..$deletion_amount {
    # print $"($name) rm -fr (($systems | get $index).name)"
    rm -fr (($systems | get $index).name)
  }
}

def main [amount_to_keep: int = 10] {
  cleanup_profiles "system-profiles"  (ls /nix/var/nix/profiles/system*) $amount_to_keep
  if ('/home/ole/.local/state/nix/profiles' | path exists) {
    cleanup_profiles "ole-user" (ls /home/ole/.local/state/nix/profiles/home-manager*) $amount_to_keep
  }

  /run/current-system/sw/bin/nix-collect-garbage
}
