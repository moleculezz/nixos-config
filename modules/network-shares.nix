{
  flake.modules.nixos.network-shares = { lib, pkgs, ... }:
    let
      # Shares are mounted manually (interpmount/interpumount) and deliberately
      # have no x-systemd.automount: autofs placeholders for unreachable shares
      # break bubblewrap/buildFHSEnv apps (e.g. pdfstudio2024), which fail with
      # "bwrap: Can't bind mount /mnt ... No such device" when off the network.
      # The server is an IP because nas.local (mDNS) doesn't resolve over WireGuard.
      server ="192.168.1.65";
      shares = [ "accounting" "clients" "ctprint" "data" "share" ];
      mkWorkShare = shareName: {
        device = "//${server}/${shareName}";
        fsType = "cifs";
        options = [
          "credentials=/etc/nixos/smb-secrets-interprint"
          "uid=1000"
          "gid=100"
          "vers=3.0"
          "sec=ntlmssp"
          "domain=INTERPRINT"
          "file_mode=0664,dir_mode=0775"
          "noauto"
          "nofail"
          "_netdev"
          "x-systemd.mount-timeout=10s"
        ];
      };
      forShares = cmd: lib.concatMapStringsSep "\n" cmd shares;
    in {
      fileSystems = lib.listToAttrs (map (s: {
        name = "/mnt/interprint/${s}";
        value = mkWorkShare s;
      }) shares);

      environment.systemPackages = [
        (pkgs.writeShellScriptBin "interpmount" (forShares (s: "sudo mount /mnt/interprint/${s}")))
        (pkgs.writeShellScriptBin "interpumount" (forShares (s: "sudo umount -l /mnt/interprint/${s} 2>/dev/null")))
      ];

      #fileSystems."/mnt/home/homeshare" = mkHomeShare "homeshare";
    };
}
