module deploy-node-command {
  def host_completion [] {
    nix eval $'/home/ole/nixos#deploy.nodes' --apply builtins.attrNames --json | from json
  }
  
  export def --wrapped deploy-node [server: string@host_completion, ...args] {
    deploy -s $'/home/ole/nixos#($server)' ...$args
  }
}

use deploy-node-command deploy-node
