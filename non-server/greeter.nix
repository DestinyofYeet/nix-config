{ pkgs, ... }: {

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --theme "border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red"'';
        user = "greeter";
      };
    };
  };
}
