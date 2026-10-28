# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  networking.hostName = "zguegito"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";   

  # Sécurité
  boot.kernel.sysctl = {
  # Empêche l'utilisation de ptrace sur les processus en cours (limite le débogage/vol de tokens)
  "fs.suid_dumpable" = 0;
  # Désactive le routage source IP
  "net.ipv4.conf.all.accept_source_route" = 0;
  "net.ipv4.conf.default.accept_source_route" = 0;
  # Active la protection contre les SYN floods
  "net.ipv4.tcp_syncookies" = 1;
};


  # Imprimante
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # MAJ automatique
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates ="weekly";

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 5d";
  nix.settings.auto-optimise-store = true;

  # autocomplete bash
  programs.bash = {
    interactiveShellInit = ''
      source ${pkgs.blesh}/share/blesh/ble.sh
 
      ble-face auto_complete="fg=244,bg=none"
      ble-face region="bg=none"
      ble-face region_match="bg=none"




    '';
  };

  # swapfile

  swapDevices =[{
   device = "/swapfile";
   size = 4096; # 4 Go, en Mo
  }];

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.enableAllFirmware = true;
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."azotoxic" = {
    isNormalUser = true;
    description = "azotoxic";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

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
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
  
  programs.hyprland.enable = true;
  
  # Gestionnaire de connexion (ecran de login) - greetd est leger et simple
  services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    };
  };
};
  environment.variables = {
    XCURSOR_THEME = "dmz-white";
    XCURSOR_SIZE = "24";
};
  
  environment.systemPackages = with pkgs; [
   kitty
   rofi
   waybar
   btop
   fastfetch
   hyprpaper
   networkmanagerapplet
   librewolf
   waypaper
   vscode
   libreoffice-fresh
   vanilla-dmz
   fd
   fzf
   blesh
   yazi
   git
   jq
   wlogout
   obsidian
   vlc
   overskride
   flameshot
   brightnessctl
   gnome-tweaks
   obs-studio
   losslesscut
   vesktop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrains Mono" ];
    sansSerif = [ "JetBrains Mono" ];
    serif = [ "JetBrains Mono" ];
  };
# Support Wayland pour certaines apps
programs.xwayland.enable = true;

}
