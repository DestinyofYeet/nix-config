def deploy-node [server: string, --remote-build, ...args: string] {
  deploy -s $'/home/ole/nixos#($server)' (if $remote_build { "--remote-build" } else {""}) ...$args
}
