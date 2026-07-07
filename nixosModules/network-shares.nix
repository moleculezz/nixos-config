let
  mkWorkShare = shareName: {
    device = "//nas.local/${shareName}";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/smb-secrets-interprint"
      "uid=1000"
      "gid=100"
      "vers=3.0"
      "sec=ntlmssp"
      "domain=INTERPRINT"
      "file_mode=0664,dir_mode=0775"
      "x-systemd.automount"
      "noauto"
    ];
  };

in {
  fileSystems."/mnt/interprint/accounting" = mkWorkShare "accounting";
  fileSystems."/mnt/interprint/clients" = mkWorkShare "clients";
  fileSystems."/mnt/interprint/ctprint" = mkWorkShare "ctprint";
  fileSystems."/mnt/interprint/share" = mkWorkShare "share";
  fileSystems."/mnt/interprint/data" = mkWorkShare "data";
  fileSystems."/mnt/interprint/warehouse" = mkWorkShare "warehouse";
  fileSystems."/mnt/interprint/share2" = mkWorkShare "Share2Name";

  #fileSystems."/mnt/home/homeshare" = mkHomeShare "homeshare";
}
