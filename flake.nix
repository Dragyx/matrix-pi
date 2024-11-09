{
  description = "A simple Raspberry pi server with Matrix running inside docker";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # we use arion to manage the docker images / docker compose
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations."pinix" = nixpkgs.lib.nixosSystem {
      modules = [
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        inputs.disko.nixosModules.disko
        inputs.arion.nixosModules.arion
        ./configuration.nix
        ./docker.nix
        ./disk.nix
      ];
    };
  };
}
