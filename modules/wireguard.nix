{
  flake.modules.nixos.wireguard = { pkgs, ... }: {
    #networking.firewall = {
    #  allowedUDPPorts = [ 51828 ];
    #};

    networking.wg-quick.interfaces = {
      wgHome = {
        autostart = false;
        address = [ "10.8.88.5/32" ];
        #listenPort = 51828;
        privateKeyFile = "/home/gd/wireguard-keys/private";

        peers = [
          {
            publicKey = "zluk9U/dQ23rw4vPbI2d/WxSp8roSLigNWaeJFKAykA=";
            allowedIPs = [ "10.8.88.0/24" "10.8.8.0/24" ];
            endpoint = "home.nospida.life:51828";
            #persistentKeepalive = 25;
          }
        ];
      };

      wgInterprint = {
        autostart = false;
        address = [ "172.16.10.2/32" ];
        listenPort = 51621;
        privateKeyFile = "/home/gd/wireguard-keys/private";

        peers = [
          {
            publicKey = "YVT8YvHUtjXWwxP5do2jylbFzZS9dM9z+vnwto8bJD0=";
            allowedIPs = [ "172.16.10.0/24" "192.168.1.0/24" ];
            endpoint = "graycloud.interprint.network:51621";
            #persistentKeepalive = 25;
          }
        ];
      };
    };

    # Define NetworkManager dispatcher script using the proper NixOS way
    networking.networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeText "90-wireguard" ''
          #!/run/current-system/sw/bin/bash

          INTERFACE="$1"
          ACTION="$2"

          # Get current SSID
          CURRENT_SSID=$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

          # Define trusted networks
          if [[ "$CURRENT_SSID" == "Wayaless" || "$CURRENT_SSID" == "Thingies" ]]; then
            logger -t wireguard-dispatcher "Connected to trusted network '$CURRENT_SSID', disabling Wireguard"
            ${pkgs.systemd}/bin/systemctl stop wg-quick-wgHome.service
          else
            logger -t wireguard-dispatcher "Connected to untrusted network '$CURRENT_SSID', enabling Wireguard"
            ${pkgs.systemd}/bin/systemctl start wg-quick-wgHome.service
          fi
        '';
        type = "basic";
      }
    ];
  };
}
