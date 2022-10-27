{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services.upower.enable = true;

  services.gnome = {
    gnome-keyring.enable = true;
  };

  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  services.xserver = {
    enable = true;

#    extraLayouts.us-custom = {
#      description = "US layout with custom hyper keys";
#      languages = [ "eng" ];
#    };
#
#    layout = "us-custom";

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    displayManager = {
      sddm.enable = true;
      defaultSession = "none+xmonad";
    };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

#   hardware.bluetooth = {
#     enable = true;
#     hsphfpd.enable = true;
#     settings = {
#       General = {
#         Enable = "Source,Sink,Media,Socket";
#       };
#     };
#   };

#   services.blueman.enable = true;

  systemd.services.upower.enable = true;
}
