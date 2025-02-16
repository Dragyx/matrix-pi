{
  pkgs,
  lib,
  ...
}: let
  username = "mpi";
  inherit (lib) getExe;
in {
  # firewall and networking settings
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      passwordAuthentication = false;
      AllowUsers = [username];
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };
  services.fail2ban.enable = true;
  networking = {
    hostname = "pinix";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
  };
  time.timeZone = "Europe/Zurich";
  # user settings
  users.users."mpi" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3XC/ac66Vq3hhEm0LDoRE1+dhEnaUPwHlC2AD6xIzl matrix-pi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPDxn5uAmY2qDEIal6m698CQpDdUZcLjOfmBG7Jcy4V dragyx@flocke"
    ];
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = getExe pkgs.fish;
    initialPassword = "mpi";
  };

  # basic quality of live packages
  environment.systemPackages = with pkgs; [
    helix
    bat
    fish
    git
    lazygit
    libraspberrypi
    raspberrypi-eeprom
    docker-compose
  ];
  programs.nh = {
    enable = true;
    flake = "/home/${username}/flake";
  };
  # enable docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # system stuff
  # partly taken from: https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_4
  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  hardware.raspberry-pi."4".fkms-3d.enable = true;
  console.enable = false;
  system.stateVersion = "24.05";
}
