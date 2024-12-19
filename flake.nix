{
    description = "AUTOMATIC1111/stable-diffusion-webui flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
        in {
            devShells = rec {
                cpu = import ./impl.nix { inherit pkgs; variant = "CPU"; };
                cuda = import ./impl.nix { inherit pkgs; variant = "CUDA"; };
                rocm = import ./impl.nix { inherit pkgs; variant = "ROCM"; };
                default = nixpkgs.lib.warn ''
                    To use a version with GPU support, specify which output you want:
                      - nix develop .#cuda
                      - nix develop .#rocm
                    Defaulting to: nix develop .#cpu
                '' cpu;
            };
        }
    );
}
