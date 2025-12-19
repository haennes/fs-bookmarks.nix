{ osConfig, inputs, ... }:
{
  imports = [
    inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default
    inputs.fs-bookmarks.homeManagerModules.default
  ];
  inherit (osConfig) fs-bookmarks;
  home.stateVersion = "25.11";
  programs.yazi = {
    enable = true;
    yaziPlugins = {
      enable = true;
      plugins.yamb.enable = true;
    };
  };
}
