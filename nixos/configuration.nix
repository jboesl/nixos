
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "vm.swappiness" = 15;
      "vm.min_free_kbytes" = 65536;
    };
    loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = true;
      grub.device = "/dev/sda5";
      grub.efiSupport = true;
      grub.useOSProber = true;
      grub.gfxmodeEfi = "1920x1080";
      grub.splashImage = "/home/bo/nixos/Minimalistic-Wallpaper-09.png";
    };
  };

  networking = {
    hostName = "notepal";
    networkmanager.enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    wget neovim wakelan htop p7zip keepassx2 ntfs3g
    krusader kdiff3 krename
    google-chrome thunderbird gimp vlc libreoffice atom
    remmina x2goclient
    skype discord steam
    git jdk
    maven jetbrains.idea-community
    docker docker_compose
    networkmanager-openvpn openvpn gnome3.gnome-bluetooth bluez
  ];

  programs = {
    mtr.enable = true;
    gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
  };

  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      layout = "de";

      # libinput is preferred but synaptics works better on my acer
      libinput.enable = false;
      synaptics.enable = true;
      synaptics.twoFingerScroll = true;
      synaptics.tapButtons = true;
      synaptics.fingersMap = [ 1 3 2 ];
      synaptics.palmDetect = true;

      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
  };

  users.mutableUsers = false;
  users.users.bo = {
    packages = [pkgs.steam];
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound" "pulse" "audio" ];
    hashedPassword = "$6$CO5LV1JiIQ6pGQ$ZbiYmXZavqm8nF29wkXRE0qCn/RXN9Uw8I5CUEiG8QHKW7iLwiv1xNDo9Bsd0n6gTog0AHZGYU7XBOpWZ9AEk/";
    shell = pkgs.fish;
  };

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
