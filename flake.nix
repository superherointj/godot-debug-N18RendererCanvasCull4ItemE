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
          empty = pkgs.callPackage ./empty.nix {
            # Godot version is pinned to 4.2.beta5
            godot_4 = pkgs.godot_4_2_beta6;
            godot_4-export-templates = pkgs.godot_4_2_beta6-export-templates;
          };
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
