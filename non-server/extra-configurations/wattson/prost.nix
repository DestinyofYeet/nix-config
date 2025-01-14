{
  ...
}:{
  services.prost = {
    enable = true;

    backend = {
      volumePath = "/home/ole/tmp/prost/prost";
    };

    mariadb = {
      configDir = "/home/ole/tmp/prost/db";
    };

    ldapUri = "ldaps://adldap.hs-regensburg.de";

    ldap = {
      dir = "/home/ole/tmp/prost/ldap";
      root = "cn=IM_FSIM_Srv,ou=Servicekennungen,ou=Benutzer,ou=IM,ou=HSR,dc=hs-regensburg,dc=de";
    };
  };
}
