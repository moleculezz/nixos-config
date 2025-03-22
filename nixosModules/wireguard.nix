{pkgs, ...}: {


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
  };

  # Create the NetworkManager dispatcher script
  environment.etc."NetworkManager/dispatcher.d/90-wireguard" = {
    mode = "0755";
    text = ''
      #!/run/current-system/sw/bin/bash

      INTERFACE="$1"
      ACTION="$2"
      WIREGUARD_INTERFACE="wgHome"

      # Define trusted SSIDs (where Wireguard should NOT be enabled)
      TRUSTED_SSIDS=(
        "Wayaless"
        "Thingies"
      )

      # Only proceed for wireless interfaces when connection changes
      if [[ "$INTERFACE" =~ ^wl.* ]] && [[ "$ACTION" == "up" || "$ACTION" == "down" ]]; then
        # If network is down, enable Wireguard
        if [[ "$ACTION" == "down" ]]; then
          logger -t wireguard-dispatcher "Network down, enabling Wireguard VPN"
          systemctl start wg-quick-wgHome.service
          exit 0
        fi

        # For "up" actions, determine if we're on a trusted network
        CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

        if [[ -z "$CURRENT_SSID" ]]; then
          logger -t wireguard-dispatcher "Could not determine SSID, enabling Wireguard VPN"
          systemctl start wg-quick-wgHome.service
          exit 0
        fi

        # Check if current SSID is in our trusted list
        for SSID in "''${TRUSTED_SSIDS[@]}"; do
          if [[ "$CURRENT_SSID" == "$SSID" ]]; then
            logger -t wireguard-dispatcher "Connected to trusted network '$CURRENT_SSID', disabling Wireguard VPN"
            systemctl stop wg-quick-wgHome.service 2>/dev/null || true
            exit 0
          fi
        done

        # If we're here, we're on an untrusted network
        logger -t wireguard-dispatcher "Connected to untrusted network '$CURRENT_SSID', enabling Wireguard VPN"
        systemctl start wg-quick-wgHome.service
      fi
    '';
  };
}
