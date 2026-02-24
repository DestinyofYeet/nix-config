module deploy-node-command {
  def host_completion [] {
    nix eval $'/home/ole/nixos#deploy.nodes' --apply builtins.attrNames --json | from json
  }
  
  export def --wrapped deploy-node [server: string@host_completion, ...args] {
    deploy -s $'/home/ole/nixos#($server)' ...$args -- --log-format internal-json -v o+e>| nom --json
  }

  export def --wrapped deploy-nodes [ nodes: string, ...args] {
    let hosts = $nodes | split row "," | each { $in | "/home/ole/nixos#" + $in} | str join " ";
    print $"deploy -s --targets $'($hosts)' ...$args -- --log-format internal-json -v o+e>| nom --json"
  }
}

use deploy-node-command [deploy-node deploy-nodes]
