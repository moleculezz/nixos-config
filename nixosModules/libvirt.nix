{ config, pkgs, userSettings, ... }:
{
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

  users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];

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

  #home-manager.users.${userSettings.username} = {
  #  dconf.settings = {
  #    "org/virt-manager/virt-manager/connections" = {
  #      autoconnect = [ "qemu:///system" ];
  #      uris = [ "qemu:///system" ];
  #    };
  #  };
  #};
}
