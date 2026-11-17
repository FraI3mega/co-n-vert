{
  description = "A minimal flake template that you can adapt to your own project";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, rust-overlay, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ (import rust-overlay) ];
          };

          devShells.default = pkgs.mkShell {
            packages =
              with pkgs;
              [
                config.formatter
                (rust-bin.selectLatestNightlyWith (
                  toolchain:
                  toolchain.default.override {
                    extensions = [ "rust-analyzer" ];
                  }
                ))
                bacon
                cargo-nextest
              ]
              ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
                mold
                clang
              ];

          };

          formatter = pkgs.nixfmt;
        };
    };
}
