{ config, inputs, ... }:
{
  flake.nixosConfigurations.gnix = inputs.nixpkgs.lib.nixosSystem {
    system = config.settings.system;
    specialArgs = { inherit inputs; };

    modules = with inputs.self.modules.nixos; [
      # Configure Framework 13 7040 AMD laptop specific config.
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd

      # Configure disk partitioning
      inputs.disko.nixosModules.disko
      ../../hosts/gnix/disk-configuration.nix

      # Other hardware specific config.
      ../../hosts/gnix/hardware-configuration.nix

      core
      fonts
      utilities
      network-shares
      office
      multimedia
      development
      crypto
      internet
      wireguard
      libvirt
      game
      neovim
      #davinci-resolve
      onepassword
      razer

      { my.fonts.enable = true; }
    ];
  };
}
