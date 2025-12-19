{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkMerge
    mapAttrsToList
    ;
  cfg = config.fs-bookmarks;
  inherit (import ./module-let-in-shared.nix { inherit cfg lib; })
    shellAliases
    programsShellAliases
    programsShellAliasesFunc
    ;
  useDirStack = cfg.useDirectoryStack;
  nushellShellAliasFromBookmark =
    _: bookmark:
    let
      inherit (bookmark) dir;
    in
    if useDirStack then "use std/dirs; dirs add ${dir}" else "cd ${dir}";
in
{
  config = lib.mkIf cfg.enable {
    home.shellAliases = mkIf cfg.useToplevelShellAliases shellAliases;

    programs = mkIf (!cfg.useToplevelShellAliases) (mkMerge [
      (programsShellAliases [
        "bash"
        "ion"
        "fish"
        "zsh"
      ])
      (programsShellAliasesFunc nushellShellAliasFromBookmark [ "nushell" ])
      (lib.mkIf cfg.set.yazi.yamb {
        yazi.yaziPlugins.plugins.yamb.bookmarks = (
          mapAttrsToList (key: value: {
            inherit (value) tag;
            path = value.dir;
            inherit key;
          }) cfg.bookmarks
        );
      })
    ]);
  };

}
