{ lib, ... }{
  with lib;

  options.customServiceSettings = {
    user = "apps";
    group = "apps";
  };
};
