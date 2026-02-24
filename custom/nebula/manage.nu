  def "main gen-ca" [] {
  # Will generate a ca.key for 99 years
  nebula-cert ca -name "YeetsNetwork" -duration 867800h
  print "DO NOT COMMIT ca.key !!!"
};

def "main create-host" [name: string] {
  mut found_host = null;

  for host in (nix eval --json -f ./machines.nix | from json | transpose "key" "value") {
    let hname = $host.key;
    let hvalue = $host.value;

    if $name == $hname {
      $found_host = $hvalue
    }
  }

  if $found_host == null {
    print $"Failed to find host ($name) in machines.nix"
    return;
  }

  nebula-cert sign -name $name -ip $"($found_host.ip)/24" -groups $"($found_host.groups | str join ",")"
}

def "main create-hosts" [] {
  for host in (nix eval --json -f ./machines.nix | from json | transpose "key" "value") {
    let name = $host.key;
    main create-host $name 
    # print $"Would create host ($name) with ip ($value.ip)/24 and groups ($value.groups | str join ",")"
  }
}

def "main sign-pub" [pub: path, name: string, ip: string, groups: string] {
  nebula-cert sign -in-pub $pub -name $name -ip $ip --groups $groups
}

def "main rekey" [] {
  ls | where type == dir | each { cd $in.name; agenix -r; cd ..}
}

def "main re-encrypt-keys" [] {
  for host in (ls | where type == dir) {
    let name = $host.name;
    cp ./ca.crt $"($name)/";
    cp $"./($name).crt" $"($name)/";
    cd $name;
    open $"../($name).key" | agenix -e $"($name).key.age";
    cd ..;
  }
}

def "main clean" [] {
  for dir in (ls | where type == dir) {
    let name = $dir.name;
    rm $"($name).key" $"($name).crt";
  }
}

def main [] {
  print "Possible subcommands: gen-ca, create-host, create-hosts, rekey, sign-pub, re-encrypt-keys, clean"
}
