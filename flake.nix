{
  description = "Garnix Immich Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    garnix-lib = {
      url = "github:garnix-io/garnix-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      garnix-lib,
      ...
    }:
    {
      nixosConfigurations.immich = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          garnix-lib.nixosModules.garnix
          {
            garnix.server = {
              enable = true;
              persistence = {
                enable = true;
                name = "immich";
              };
            };
          }
          ./configuration.nix
        ];
      };
    };
}
