# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:



# This was just added so you might what to look at it
#let
#  unstable = import (builtins.fetchTarball {
#    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
#  }) {config = config.nixpkgs.config;};
#  nix-software-center = import (pkgs.fetchFromGitHub {
#    owner = "snowfallorg";
#    repo = "nix-software-center";
#    rev = "0.1.2";
#    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
#  }) {pkgs = unstable;};
#in
#This is the end of what was added above


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Display Manager
	services.xserver.displayManager.lightdm.enable = true;
	#services.xserver.displayManager.lightdm.autoLogin.enable = true;
	#services.xserver.displayManager.lightdm.autoLogin.user = "bob";
	#services.xserver.displayManager.gdm.enable = true;
	#services.xserver.displayManager.sddm.enable = true;
	
	#Window Manager
	#services.xserver.windowManager.icewm.enable = true;
	
	
	#Enable the Desktop Environment.
  	services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  	services.printing.enable = true;
	services.printing.drivers = [ pkgs.gutenprint pkgs.epson-201106w pkgs.epson-escpr ]; 
	services.printing.browsing = true;
	programs.system-config-printer.enable = true;
	services.system-config-printer.enable = true;
#	hardware.printers.ensurePrinters.*.model = true;
#	hardware.printers.ensurePrinters.*.deviceUri = true;			
	services.avahi = {
  	enable = true;
#  	nssmdns = false;
  	openFirewall = true;
	};


  services.avahi.nssmdns = false; # Use the settings from below
  # settings from avahi-daemon.nix where mdns is replaced with mdns4
  system.nssModules = pkgs.lib.optional (!config.services.avahi.nssmdns) pkgs.nssmdns;
  system.nssDatabases.hosts = with pkgs.lib; optionals (!config.services.avahi.nssmdns) (mkMerge [
    (mkBefore [ "mdns4_minimal [NOTFOUND=return]" ]) # before resolve
    (mkAfter [ "mdns4" ]) # after dns
  ]);

	

# Enable doc scanning
#	services.sane.enable = true;
	hardware.sane.extraBackends = [ pkgs.epkowa ];
#	hardware.sane.extraBackends = [ pkgs.utsushi ];
#	services.udev.packages = [ pkgs.utsushi ];
	
	
	hardware.sane.enable = true; # enables support for SANE scanners
	
	services.ipp-usb.enable = true;


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
 
  #Jellyfin Server

	services.jellyfin = {
	enable = true;
	openFirewall = true;
	user="bob";
	};

  #Flatpak
#	services.flatpak.enable = true;
#	xdg.portal = {
#	enable = true;
#	wlr.enable = true;
#	};


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bob = {
    isNormalUser = true;
    description = "bob";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
    packages = with pkgs; [
      	#nix-software-center
	firefox
      	kate
     	thunderbird
	wget
	screen
	filezilla
	htop
	lynx
	jellyfin
	jellyfin-web
	jellyfin-ffmpeg
	gparted
	geany
	libreoffice
	homebank
	git
	curl
	anydesk
	brave
	simple-scan
	vlc
	gtklp
   ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
   networking.firewall.allowedUDPPorts = [ 5353 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
