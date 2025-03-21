{ config, pkgs, inputs, userSettings, ... }:
{
  imports = [ 
    # Configure Framework 13 7040 AMD laptop specific config.
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    # Configure disk partitioning
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix

    # Other hardware specific config.
    ./hardware-configuration.nix

    # Configure system wide theme
    #inputs.stylix.nixosModules.stylix

    ./configuration.nix

    ../../nixosModules

  ];

  #my.hyprland.enable = false;
  my.fonts.enable = true;
}
