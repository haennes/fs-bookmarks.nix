{ ... }:
{
  networking.hostName = "pcA";
  boot.isContainer = true; # Hack to have an easy time building
  system.stateVersion = "25.11";
  users.users.jdoe = {
    isNormalUser = true;
    group = "jdoe";
  };
  users.groups.jdoe = { };

  fs-bookmarks = {
    enable = true;
    useToplevelShellAliases = false; # default to false
    useDirectoryStack = false;
    set = {
      shell = {
        ion = true;
        bash = true;
        fish = true;
        nushell = true;
        zsh = true;
        # see list in hm
      };
      yazi = {
        yamb = true;
      };
    };
    bookmarks = {
      "d" = {
        tag = "Downloads";
        dir = "$HOME/Downloads";
        description = "The download directory";
      };
    };
  };
}
