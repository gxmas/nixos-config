{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      bach = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ system/configuration.nix ];
      };
    };

    homeConfigurations = {
    };
  };
}
