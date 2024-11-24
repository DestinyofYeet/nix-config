def --wrapped deploy-node [server: string, ...args] {
  deploy -s $'/home/ole/nixos#($server)' ...$args
}
