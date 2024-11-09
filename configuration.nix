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
  networking.firewall = {
  };

  # user settings
  users.users."mpi" = {
    openssh.authorizeddKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3XC/ac66Vq3hhEm0LDoRE1+dhEnaUPwHlC2AD6xIzl matrix-pi"
    ];
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
  ];

  programs.nh = {
    enable = true;
    flake = "/home/${username}/flake";
  };
}
