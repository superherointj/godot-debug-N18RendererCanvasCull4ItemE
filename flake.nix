{
  description = "Flake utils demo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-friendly-overlay.url = "github:nixpkgs-friendly/nixpkgs-friendly-overlay";
    nixpkgs-friendly-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-friendly-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixpkgs-friendly-overlay.overlays.default ];
      };
      in
      {
        packages = rec {
          empty = pkgs.callPackage ./empty.nix { };
          default = empty;
        };
        apps = rec {
          empty = flake-utils.lib.mkApp {
            drv = self.packages.${system}.empty;
          };
          default = empty;
        };
      }
    );
}
