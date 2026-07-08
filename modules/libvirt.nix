{ config, ... }:
let
  username = config.settings.username;
in {
  flake.modules.nixos.libvirt = { pkgs, ... }: {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };

    users.users.${username}.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
      virtio-win
      #win-spice
    ];
    programs.virt-manager.enable = true;

    # Enable GPU Passthrough to Windows VM
    #boot.loader.systemd-boot.extraEntries = {
    #  "gpu_passthrough.conf" = ''
    #  amd_iommu=on iommu=pt iommu=1 video=efifb:off disable_idle_d3=1
    #  '';
    #};
  };
}
