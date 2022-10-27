{ config, pkgs, ... }:

{
  imports = [
    hardware/configuration.nix
    wm/xmonad.nix
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "==delete-older-than 7d";
    };

    package = pkgs.nixVersions.stable;
#     registry.nixpkgs.flake = input.nixpkgs;

    settings = {
#      auto-optimize-store = true;
      trusted-users = [ "root" "gnoel" ];
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  # Use the GRUB 2 boot loader
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        # canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
	efiInstallAsRemovable = true;
        device = "nodev";
      };
    };
  };

  # Setup networking
  networking = {
    hostName = "bach";

    # Enable wireless support
    wireless.iwd = {
      enable = true;

      settings = {
        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
        Settings = {
          AutoConnect = true;
        };
        Scan = {
          DisablePeriodicScan = true;
        };
      };
    };

    interfaces = {
      wlan0.useDHCP = true;
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    firewall.enable = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    alacritty
    git
    vim
    zsh
  ];

  # Enable Docker support
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Enable Sound
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Mount MTP devices
  services.gvfs.enable = true;

  # SSH daemon
  services.openssh.enable = true;

  # Make fonts accessible to applications
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Enable GnuPG agent
  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  programs.zsh.enable = true;

  users.users.gnoel = {
    isNormalUser = true;
	initialPassword = "welcome123";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
