{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.fs-bookmarks;
  inherit (import ./module-let-in-shared.nix { inherit cfg lib; }) shellAliases programsShellAliases;
in

{
  config = lib.mkIf cfg.enable {
  environment.shellAliases = mkIf cfg.useToplevelShellAliases shellAliases;

  programs = mkIf (!cfg.useToplevelShellAliases) (programsShellAliases [
    "zsh"
    "bash"
    "fish"
  ]);
  };


}
