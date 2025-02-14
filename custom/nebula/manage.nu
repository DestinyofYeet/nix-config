def "main gen-ca" [] {
  # Will generate a ca.key for 99 years
  nebula-cert ca -name "YeetsNetwork" -duration 867800h
  print "DO NOT COMMIT ca.key !!!"
};

def "main create-host" [name: string, ip: string, groups: string] {
  nebula-cert sign -name $name -ip $ip -groups $groups
}

def "main create-hosts" [] {
  for host in (open ./ip_map.json) {    
    main create-host $host.name $"($host.ip)/24" $host.groups
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
