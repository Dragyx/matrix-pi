{
  boot = {
    initrd.supportedFilesystems = ["btrfs"];
    supportedFilesystems = ["btrfs"];
    loader = {
      efi.efiSysMountPoint = "/boot";
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
  };
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "pinix-boot";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["defaults"];
            };
          };
          root = {
            label = "pinix-root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-L" "pinix-boot" "-f"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = ["subvol=log" "compress=zstd" "noatime"];
                };
                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "8G";
                };
              };
            };
          };
        };
      };
    };
  };
}
