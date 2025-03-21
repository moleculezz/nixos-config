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
}
