{
  inputs, lib
}:{
  mkIfLaptop = config : attr : 
    lib.mkIf (config.networking.hostName == "wattson") attr;
}
