{ lib, inputs, config, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.settings = lib.mkOption {
    type = lib.types.submodule {
      options = {
        username = lib.mkOption { type = lib.types.str; };
        name = lib.mkOption { type = lib.types.str; };
        hostname = lib.mkOption { type = lib.types.str; };
        hostId = lib.mkOption { type = lib.types.str; };
        system = lib.mkOption { type = lib.types.str; };
        homeDir = lib.mkOption { type = lib.types.str; };
        timezone = lib.mkOption { type = lib.types.str; };
        locale = lib.mkOption { type = lib.types.str; };
        keyboardLayout = lib.mkOption { type = lib.types.str; };
      };
    };
  };

  config.settings = {
    username = "gd";
    name = "GD";
    hostname = "gnix";
    hostId = "06919496";
    system = "x86_64-linux";
    homeDir = "/home/${config.settings.username}";
    timezone = "America/Aruba";
    locale = "en_US.UTF-8";
    keyboardLayout = "us";
  };
}
