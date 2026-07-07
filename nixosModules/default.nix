{ config, pkgs, ... }:
{
  imports =
    [ 
      # Add styling & theming
      #./stylix.nix
      #./hyprland
      ./fonts
      ./utilities.nix
      ./network-shares.nix
      ./office.nix
      ./multimedia.nix
      ./development.nix
      ./crypto.nix
      ./internet.nix
      ./wireguard.nix
      ./libvirt.nix
      ./game.nix
    ];
  }
