{
  ...
}:{
  systemd.tmpfiles.rules = [
    "A+ /mnt/data/data/Programming-Stuff/ - - - - user:apps:rwx"
    "A+ /mnt/data/data/Programming-Stuff/ - - - - other::x"
  ];
}
