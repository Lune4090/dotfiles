# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-intel
      common-gpu-intel
      common-pc-ssd
    ])
    ++ [
      inputs.xremap.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
  };

  # Configure console keymap
  console.keyMap = "jp106";




  # prevent OOM kill
  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    flatpak.enable = true;
    xserver = {
      libinput.enable = true;
      desktopManager.runXdgAutostartIfNone = true;
    };
    xremap = {
      userName = "Lune";
      serviceMode = "system";
      config = {
        modmap = [
          {
            name = "Caps2Ctrl&NoTransMod4";
            remap = {
              CapsLock = "Ctrl_L";
              Muhenkan = "SUPER_L";
            };
          }
        ];
      }; 
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerdfonts
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["NotoColor Emoji"];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lune = {
    isNormalUser = true;
    description = "Lune";
    extraGroups = [ "networkmanager" "wheel" "light" "audio"];
    packages = with pkgs; [
    ];
  };

  environment = {
    pathsToLink = ["/libexec"];
    systemPackages = with pkgs; [
      # CLI app
      wget
      curl
      ripgrep
      eza
      pulseaudio
      brightnessctl
      highlight # make source code colorful

      # Terminal&Editor
      helix
      alacritty

      # TUI app
      bottom
      neofetch
      ranger

      # GUI app
      firefox
      thunderbird
      arandr
      vscode
      pavucontrol

      # programing language specific
      rustup
      rust-analyzer
      julia
      (python3.withPackages (ps: with ps; [
        pandas
        gpaw
        ase
        matplotlib
        numpy
      ]))
      clang
      llvm
      marksman
      pyright

      # hyprland specific
      waybar
      mako
      libnotify
      swww
      rofi-wayland
      winetricks
      wineWowPackages.waylandFull
    ];
  };

  programs = {
    git = {
      enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    nix-ld.enable = true;
    # enable nix-pkgs
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

  };

  # desktop portals (handles desktop app(link open/screen share))
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ 
    xdg-desktop-portal-hyprland
  ];

  environment.variables = {
    EDITOR = "hx";
  };
    
  lib.mkForce = {
    environment.variables = {
      NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
      JULIA_SSL_CA_ROOTS_PATH = lib.mkForce "/etc/ssl/certs/ca-bundle.crt";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
