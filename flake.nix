{
  description = "filesystem bookmarks abstraction for nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      pkgsForSystem = system: (import nixpkgs { inherit system; });
    in
    {
      nixosModules = rec {
        fs-bookmarks = import ./module.nix {
          kind = "system";
          topLevelShellAliasName = "environment.shellAliases";
        };
        default = fs-bookmarks;
      };
      homeManagerModules = rec {
        fs-bookmarks = import ./module.nix {
          kind = "home-manager";
          topLevelShellAliasName = "home.shellAliases";
        };
        default = fs-bookmarks;
      };
      formatter = forAllSystems (
        system:
        let
          pkgs = (pkgsForSystem system);
        in
        pkgs.nixfmt-rfc-style
      );
    };
}
