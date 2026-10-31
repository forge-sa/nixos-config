{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "forge-sa";
        email = "sardar@altynkhan.com";
      };
      init.defaultBranch = "main";
      # First push of a new branch works without `--set-upstream`
      push.autoSetupRemote = true;
      # Always use SSH for GitHub, even when a repo was cloned with an https:// URL
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
