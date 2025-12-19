{
  description = "filesystem bookmarks abstraction for nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fs-bookmarks = {
      url = "..";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      # follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      fs-bookmarks,
      home-manager,
      nix-yazi-plugins,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      pkgsForSystem = system: (import nixpkgs { inherit system; });
    in
    {
      nixosConfigurations.pcA = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./example.nix
          fs-bookmarks.nixosModules.fs-bookmarks
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jdoe = ./home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
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
