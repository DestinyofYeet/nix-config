{ ... }: {
  services.smartd = {
    # enabled through baseline
    # will start a short self-test every day between 2-3am, and an extended self test weekly on Saturdays between 3-4am
    defaults.autodetected = "-a -s (S/../.././02|L/../../6/03)";
    notifications = {
      # test = true;
      mail = {
        enable = true;
        sender = "smartd@ole.blue";
        recipient = "ole@ole.blue";
      };
    };
  };
}
