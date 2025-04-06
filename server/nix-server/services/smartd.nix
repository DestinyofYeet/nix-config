{ ... }: {
  services.smartd = {
    # enabled through baseline
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
