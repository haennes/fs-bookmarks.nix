# fs-bookmarks.nix

Easily declare bookmarks in one place and use them everywhere

## Installation

In your `flake.nix`, add the input like so:
```nix
{
  inputs.fs-bookmarks = {
    url = "github:haennes/fs-bookmarks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ...
}
```

Then you can use the homeManagerModule or the system wide nixosModule.

**Find out how to pass in the modules by looking at the [example files](./example)

## Tip
If you want the same bookmarks system wide as per user you can simply do the following in home-manager:
```nix
{osConfig, ...}: {
  ...  
  inherit (osConfig) fs-bookmarks;
  ...
}
```

Feel free to make a quick pr to add more bookmark "targets" or improve Documentation :)

