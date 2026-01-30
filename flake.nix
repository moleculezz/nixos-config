{
  description = "Framework 13 AMD flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Disk manager
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    affinity-nix.url = "github:mrshmllow/affinity-nix";

    # Hyprland
    #hyprland.url = "github:hyprwm/Hyprland";
    #hyprland-plugins = {
    #  url = "github:hyprwm/hyprland-plugins";
    #  inputs.hyprland.follows = "hyprland";
    #};

    #sddm-sugar-catppuccin = {
    #  url = "github:TiagoDamascena/sddm-sugar-catppuccin";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #stylix = {
    #  url = "github:danth/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.home-manager.follows = "home-manager";
    #};
  };

  outputs = { nixpkgs, nixos-hardware, disko, ghostty, zen-browser, affinity-nix, ...}@inputs:

  let 
    systemSettings = {
      system = "x86_64-linux";
      hostname = "gnix";
    };

    userSettings = {
      username = "gd";
      name = "GD";
      homeDir = "/home/${userSettings.username}";
    };

    specialArgs = { inherit inputs; inherit systemSettings; inherit userSettings; };

  in
  {

    nixosConfigurations = {
      gnix = nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        system = systemSettings.system;

        modules = [
          ./hosts/gnix
        ];
      };
    };
  };
}
