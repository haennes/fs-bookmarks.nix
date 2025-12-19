{
  kind, # either system or home-manager
  topLevelShellAliasName,
}:
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options =
    let
      inherit (lib)
        listToAttrs
        mkOption
        mkEnableOption
        ;
      inherit (lib.types)
        attrsOf
        either
        path
        submodule
        str
        nullOr
        ;
    in
    {
      fs-bookmarks = {
        enable = mkEnableOption "wether to enable bindfs.nix";
        useToplevelShellAliases = mkEnableOption "wether to use ${topLevelShellAliasName}";
        useDirectoryStack = mkEnableOption "wether to enable using the directory stack allowing for easier navigation back";
        #TODO assert that set and useToplevelShellAliases dont conflict
        set = {
          shell = listToAttrs (
            map
              (n: {
                name = n;
                value = mkEnableOption "wether to add the aliases to ${n}";
              })
              [
                "ion"
                "bash"
                "fish"
                "nushell"
                "zsh"
              ]
          );
          yazi.yamb = mkEnableOption "wether to add the bookmarks to yazi yamb";
        };
        bookmarks = mkOption {
          type = attrsOf (
            submodule (
              { name, ... }:
              {
                options = {
                  tag = mkOption {
                    type = str;
                    description = "A tag associated with the folder - usually a human readable name";
                    default = name;
                  };
                  dir = mkOption {
                    type = either str path;
                  };
                  description = mkOption {
                    type = nullOr str;
                    default = null;
                    description = "An optional description of the target dir";
                  };
                };
              }
            )
          );
        };
      };
    };
  imports =
    let
      modules = {
        system = import ./module-system.nix;
        home-manager = import ./module-home-manager.nix;
      };
    in
    [ modules.${kind} ];
}
