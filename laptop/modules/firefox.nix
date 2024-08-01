{ ... }:{
  programs.firefox.enable = true;

  programs.firefox.profiles = {
    {
      id = 0;
      name = "default-profile";
      isDefault = true;

      search.engines = {
        "Startpage" = {
          urls = [
            template = "https://www.startpage.com/sp/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          ]
        };
      };

      search.default = "Startpage";
    }
  };
}
