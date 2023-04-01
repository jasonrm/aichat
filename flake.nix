{
  description = "ChatGPT/GPT-3.5/GPT-4 in the terminal";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      devShells.default = pkgs.mkShell {
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustcSrc}/library";
        NIX_PATH = "nixpkgs=${pkgs.path}";

        inputsFrom = [ self.packages.${system}.default ];
        packages = with pkgs; [
          bashInteractive
          editorconfig-checker
          clippy rust-analyzer cargo-outdated cargo-audit rustfmt
        ];
      };
      packages.default = pkgs.callPackage ./package.nix { };
      overlay = self.overlays.default;
      overlays.default = final: prev: {
        aichat = final.callPackage ./package.nix { };
      };
    });
}
