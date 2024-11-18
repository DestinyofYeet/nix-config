def deploy-node [server: string, args?: string] {
  deploy -s $'/home/ole/nixos#($server)' ...($args | split row " ")
}
