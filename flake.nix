{
  description = "Schematic";

  inputs = {
    beam-flakes = {
      url = "github:mhanberg/nix-beam-flakes";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ {
    beam-flakes,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [beam-flakes.flakeModule];

      systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux"];

      perSystem = _: {
        beamWorkspace = {
          enable = true;
          devShell = {
            languageServers.elixir = false;
            languageServers.erlang = false;
          };
          versions = {
            fromToolVersions = ./.tool-versions;
          };
        };
      };
    };
}
