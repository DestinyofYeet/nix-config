def "main gen-ca" [] {
  # Will generate a ca.key for 99 years
  nebula-cert ca -name "YeetsNetwork" -duration 867800h
  print "DO NOT COMMIT ca.key !!!"
};

def "main create-host" [name: string, ip: string, groups: string] {
  nebula-cert sign -name $name -ip $ip -groups $groups
}

def "main rekey" [] {
  ls | where type == dir | each { cd $in.name; agenix -r; cd ..}
}

def main [] {
  print Possible subcommands: gen-ca
}
