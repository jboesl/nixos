# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "notepal"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget neovim wakelan htop
    firefox chromium remmina gimp vlc 
    git jdk jdk9 maven jetbrains.idea-community
    docker docker_compose
    gnome3.networkmanager_openvpn
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.fish.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable CUPS to print documents.
    # printing.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      layout = "de";
      xkbModel = "pc105";
      xkbOptions = "eurosign:e";

      # Enable touchpad support.
      #libinput.dev = "/dev/input/mouse2";
      libinput.enable = false;
      #libinput.naturalScrolling = false;
      #multitouch.enable = true;
      #multitouch.ignorePalm = true;
      synaptics.enable = true;
      synaptics.twoFingerScroll = true;
      #synaptics.buttonsMap = [ 1 3 2 ];
      synaptics.tapButtons = true;
      synaptics.fingersMap = [ 1 3 2 ];
      #synaptics.accelFactor = "0.0055";
      #synaptics.minSpeed = "0.95";
      #synaptics.maxSpeed = "1.15";
      synaptics.palmDetect = true;

      # display managers
      # displayManager.sddm.enable = true;
      # displayManager.lightdm.enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      # displayManager.slim.enable = true;

      # window managers
      # desktopManager.plasma5.enable = true;
      # desktopManager.xfce.enable = true;
      desktopManager.gnome3.enable = true;
      # windowManager.xmonad.enable = true;
      # windowManager.twm.enable = true;
      # windowManager.icewm.enable = true;
      # windowManager.i3.enable = true;  
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  
  users.users.bo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
