
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
    wget neovim wakelan htop p7zip
    chromium remmina gimp vlc libreoffice atom
    git jdk jdk9 maven jetbrains.idea-community
    docker docker_compose
    gnome3.networkmanager_openvpn
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
      xkbVariant = "neo";
      xkbModel = "pc105";
      xkbOptions = "eurosign:e";

      # libinput is preferred but synaptics works better on my acer
      libinput.enable = false;
      synaptics.enable = true;
      synaptics.twoFingerScroll = true;
      synaptics.tapButtons = true;
      synaptics.fingersMap = [ 1 3 2 ];
      synaptics.palmDetect = true;

      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome3.enable = true;
    };
  };

  users.mutableUsers = false;
  users.users.bo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$CO5LV1JiIQ6pGQ$ZbiYmXZavqm8nF29wkXRE0qCn/RXN9Uw8I5CUEiG8QHKW7iLwiv1xNDo9Bsd0n6gTog0AHZGYU7XBOpWZ9AEk/";
    shell = pkgs.fish;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
