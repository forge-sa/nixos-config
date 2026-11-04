{
  description = "flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";

    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    horizon = {
      url = "github:forge-sa/horizon-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, claude-code,  ... }: {
    nixosConfigurations.xpert = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; 
        specialArgs = {
           inherit inputs;
        };

        modules = [
          ./configuration.nix
          ./modules/flakes/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.wardar = import ./home.nix;
          }
	  ({ pkgs, ... }: {
            nixpkgs.overlays = [ claude-code.overlays.default ];
            environment.systemPackages = [ pkgs.claude-code ];
	    nix.settings.substituters = [ "https://claude-code.cachix.org" ];
            nix.settings.trusted-public-keys = [
              "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
	    ];
	  })
        ];
      };
    };
}
