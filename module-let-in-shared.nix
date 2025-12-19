{
  cfg,
  lib,
  ...
}:
let
  inherit (lib)
    mapAttrs
    listToAttrs
    map
    ;
  useDirStack = cfg.useDirectoryStack;
  shellAliasFromBookmark =
    _: bookmark:
    let
      inherit (bookmark) dir;
    in
    if useDirStack then "pushd ${dir}" else "cd ${dir}";
  shellAliasesFunc = f: mapAttrs f cfg.bookmarks;
  shellAliases = shellAliasesFunc shellAliasFromBookmark;
  programsShellAliasesFunc =
    f: aliases:
    listToAttrs (
      map (shell: {
        name = shell;
        value = {
          shellAliases = lib.mkIf cfg.set.shell.${shell} (shellAliasesFunc f);
        };
      }) aliases
    );
  programsShellAliases = programsShellAliasesFunc shellAliasFromBookmark;
in
{
  inherit
    shellAliasFromBookmark
    shellAliasesFunc
    shellAliases
    programsShellAliasesFunc
    programsShellAliases
    ;
}
